output "secret_arn" {
  description = "ARN of the secret"
  value       = aws_secretsmanager_secret.database_secret.arn
}

output "secret_id" {
  description = "ID of the secret"
  value       = aws_secretsmanager_secret.database_secret.id
}

output "secret_name" {
  description = "name of the secret"
  value       = aws_secretsmanager_secret.database_secret.name
}