###########################
#### Port Lambda Agent ####
###########################
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "${var.function_name}"
  description   = "Lambda agent which receives payloads from GetPort.io Kafka."
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  attach_policy_statements = true
  policy_statements = {
    use_kafka_secret = {
      effect    = "Allow",
      actions   = ["secretsmanager:GetSecretValue"],
      resources = [data.aws_secretsmanager_secret.port_kafka_auth_credentials.arn,data.aws_secretsmanager_secret.port_client_id.arn,data.aws_secretsmanager_secret.port_client_secret.arn]
    }
    upload_to_s3_bucket = {
      effect    = "Allow",
      actions   = ["s3:PutObject"],
      resources = ["*"]
    },
    start_codebuild = {
      effect = "Allow",
      actions = ["codebuild:StartBuild"],
      resources = ["*"]
    }
    }

  source_path = "${path.module}/src/lambda_function.py"

  environment_variables = merge(var.environment_variables,{"PORT_CLIENT_ID_SECRET_NAME" = var.port_client_id_secret_name ,"PORT_CLIENT_SECRET_SECRET_NAME" = var.port_client_secret_secret_name })

  tags = var.tags
}

#################################
#### Lambda Trigger by Kafka ####
#################################
resource "aws_lambda_event_source_mapping" "kafka_trigger" {
  function_name     = module.lambda_function.lambda_function_arn
  topics            = var.port_kafka_topics
  starting_position = "TRIM_HORIZON"

  self_managed_event_source {
    endpoints = {
      KAFKA_BOOTSTRAP_SERVERS = "${var.port_kafka_bootstrap_servers}"
    }
  }

  self_managed_kafka_event_source_config { 
    consumer_group_id = var.port_kafka_consumer_group_id
  }
  source_access_configuration {
    type = "SASL_SCRAM_512_AUTH"
    uri  = data.aws_secretsmanager_secret_version.port_kafka_auth_credentials_version.arn
  }

}