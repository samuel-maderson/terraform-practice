output "rds_dns" {
    value = aws_db_instance.rds_ssm_secret.endpoint
}

output "rds_user" {
  value = aws_db_instance.rds_ssm_secret.username
}