resource "aws_secretsmanager_secret" "database_secret" {
  name        = var.secret_name
  description = var.description
}

resource "aws_secretsmanager_secret_version" "database_secret_value" {
  secret_id     = aws_secretsmanager_secret.database_secret.id
  secret_string = jsonencode(var.secret_values)
}