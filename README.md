# terraform-aws-self-service-agent
Terraform module that creates an AWS Lambda function to act as an agent, receiving events from [Port Self-Service Hub](https://www.getport.io/product/self-service) and executing the relevant runner (implemented by AWS CodeBuild).

## Prerequisites
Before you dive into the Lambda Agent, make sure you've created your [Port secrets](https://docs.getport.io/build-your-software-catalog/sync-data-to-catalog/api/#find-your-port-credentials) (client_secret and client_id) in AWS Secret Manager. 
Ensure your secret names match the variables you'll be using. 
If you're rolling with the defaults, your secrets should be named port_client_secret and port_client_id.

```terraform
variable "port_client_secret_secret_name"{
    type = string
    default = "port_client_secret"
    description = "The name of the secret in Secret-Manager which holds the value of CLIENT_SECRET."
}

variable "port_client_id_secret_name"{
    type = string
    default = "port_client_id"
    description = "The name of the secret in Secret-Manager which holds the value of CLIENT_ID."
}
```
Additionally, you need to create a secret for [Port Kafka credentials](https://docs.getport.io/create-self-service-experiences/setup-backend/webhook/kafka/) in the AWS Secret Manager. This secret will be used as a variable: 
```terraform
variable "port_kafka_auth_credentials"{
    type = string
    default = "port_kafka_auth_credentials"
    description = "The name of the secret in Secret-Manager which holds JSON with the values 'username' and 'password' for Kafka."
}
```

## Usage
Now, add module into your Terraform code:
```terraform
module "self_service_agent"{
    source  = "Senora-dev/self-service-agent/aws"
    version = "~>1.0.0"

    port_kafka_topics = ["ORG_ID.runs"]
    port_kafka_bootstrap_servers = "kafka1:9096,kafka2:9096,kafka3:9096"
    port_kafka_consumer_group_id = "GroupIdFromPort"
}
```

## Contributing
Contributions to this project are welcome! Feel free to submit issues, feature requests, or pull requests to help improve the self-service backend.

## License
This project is licensed under the [Apache 2.0 License](LICENSE).