#--- Secrets ---#
data "aws_secretsmanager_secret" "port_client_id" {
  name = var.port_client_id_secret_name
}

data "aws_secretsmanager_secret" "port_client_secret" {
  name = var.port_client_secret_secret_name
}

data "aws_secretsmanager_secret" "port_kafka_auth_credentials" {
  name = var.port_kafka_auth_credentials
}

#--- Secrets versions ---#
data "aws_secretsmanager_secret_version" "port_client_id_version" {
  secret_id     = data.aws_secretsmanager_secret.port_client_id.id
}

data "aws_secretsmanager_secret_version" "port_client_secret_version" {
  secret_id     = data.aws_secretsmanager_secret.port_client_secret.id
}

data "aws_secretsmanager_secret_version" "port_kafka_auth_credentials_version" {
  secret_id     = data.aws_secretsmanager_secret.port_kafka_auth_credentials.id
}