# file: lambda_function.py
# lambda entrypoint: lambda_handler

import base64
import os
import logging
import json
import traceback
import boto3
import zipfile

logger = logging.getLogger()
logger.setLevel(logging.INFO)
BUCKET_PREFIX = "s3-"
CODEBUILD_SRC_ID = 'runs_bucket'

def upload_payload_to_s3_bucket(payload,bucket_name,run_id):
    s3_client = boto3.client('s3')
    response = s3_client.put_object(
        Body=(bytes(json.dumps(payload).encode('UTF-8'))),
        Bucket=bucket_name,
        Key=run_id+"/payload.json",
        ServerSideEncryption='AES256',
        StorageClass='STANDARD_IA',
    )
    return response
    
def run_codebuild(codebuild_project_name,bucket_name,run_id):
    codebuild_client = boto3.client('codebuild')
    response = codebuild_client.start_build(projectName=codebuild_project_name,secondarySourcesOverride=[{'type': 'S3','location': bucket_name + "/" + run_id +"/",'sourceIdentifier':CODEBUILD_SRC_ID}])
    return response

def lambda_handler(event, context):
    '''
    Receives an event from AWS, if configured with a Kafka Trigger, the event includes an array of base64 encoded messages from the different topic partitions
    '''
    for messages in event['records'].values():
        for encoded_message in messages:
            try:
                message_json_string = base64.b64decode(encoded_message['value']).decode('utf-8')
                logger.info('Received message:')
                logger.info(message_json_string)
                message = json.loads(message_json_string)

                ''' Upload to the bucket name with the action-identifier name 
                (should be created by the runner module: 
                https://github.com/Senora-dev/terraform-aws-self-service-runner)
                '''
                bucket_name = BUCKET_PREFIX + message["action"]
                run_id = message["context"]["runId"]

                upload_status = upload_payload_to_s3_bucket(message,bucket_name,run_id)
                print("Payload upload started to the bucket: "+bucket_name+" | STATUS: "+str(upload_status))
                run_codebuild("codebuild-"+message["action"],bucket_name,run_id)
            except Exception as e:
                traceback.print_exc()
                logger.warn(f'Error: {e}')
                return e
    return {"message": "ok"}


if __name__ == "__main__":
    pass
