output "port_client_id_arn" {
  value = data.aws_secretsmanager_secret.port_client_id.arn
}

output "port_client_secret_arn" {
  value = data.aws_secretsmanager_secret.port_client_secret.arn
}
