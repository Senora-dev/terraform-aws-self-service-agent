
variable "function_name" {
  type        = string
  default     = "port-lambda-agent"
  description = "The name of the Lambda function resource."
}

variable "port_kafka_bootstrap_servers" {
    type = string
    description = "Kafka servers string list (saprate with commas) for Lambda trigger."
}

variable "port_kafka_topics" {
    type = list(string)
    description = "Kafka topics list for Lambda trigger."
}

variable "environment_variables" {
    type = map(string)
    default = {}
}

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

variable "port_kafka_auth_credentials"{
    type = string
    default = "port_kafka_auth_credentials"
    description = "The name of the secret in Secret-Manager which holds JSON with the values 'username' and 'password' for Kafka."
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "port_kafka_consumer_group_id"{
    description = "The consumer group ID (presented in the credentials window in Port) which configured in the Kakfa Lambda trigger."
    type = string
}