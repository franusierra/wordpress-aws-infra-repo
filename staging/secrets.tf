

resource "aws_ssm_parameter" "staging_user" {
  name        = "/staging/database/user"
  description = "User for staging rds"
  type        = "SecureString"
  value       = var.db_user
  tags = {
    environment = "staging"
  }
}
resource "aws_ssm_parameter" "staging_password" {
  name        = "/staging/database/password"
  description = "Password for staging rds"
  type        = "SecureString"
  value       = var.db_password
  tags = {
    environment = "staging"
  }
}
resource "aws_ssm_parameter" "staging_db_name" {
  name        = "/staging/database/db_name"
  description = "Database name for staging rds"
  type        = "SecureString"
  value       = var.db_name
  tags = {
    environment = "staging"
  }
}
