output "mwaa_environment_name" {
  description = "Name of the MWAA environment"
  value       = aws_mwaa_environment.main.name
}

output "mwaa_webserver_url" {
  description = "Airflow UI hostname"
  value       = aws_mwaa_environment.main.webserver_url
}

output "mwaa_webserver_link" {
  description = "Paste this into a browser"
  value       = "https://${aws_mwaa_environment.main.webserver_url}"
}

output "dags_bucket" {
  value = aws_s3_bucket.dags.bucket
}

output "mwaa_status" {
  value = aws_mwaa_environment.main.status
}

output "nat_gateway_public_ip" {
  description = "Outbound IP for the private subnets"
  value       = aws_eip.nat.public_ip
}