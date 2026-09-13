output "rds_endpoint" {
  description = "Full endpoint, host:port"
  value       = aws_db_instance.app.endpoint
}

output "rds_address" {
  description = "Hostname only — this is what mysql -h wants"
  value       = aws_db_instance.app.address
}

output "rds_port" {
  description = "Port the database listens on"
  value       = aws_db_instance.app.port
}

output "db_username" {
  value = aws_db_instance.app.username
}

output "db_password" {
  description = "Master password"
  value       = var.db_password
  sensitive   = true
}

output "mysql_command" {
  description = "Ready-to-paste connection command"
  value       = "mysql -h ${aws_db_instance.app.address} -P ${aws_db_instance.app.port} -u ${aws_db_instance.app.username} -p"
}