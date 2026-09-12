output "public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
}

output "public_dns" {
  description = "Public DNS name of the web server"
  value       = aws_instance.web.public_dns
}

output "web_url" {
  description = "Browse here"
  value       = "http://${aws_instance.web.public_ip}"
}

output "ssh_command" {
  description = "Copy-paste SSH command"
  value       = "ssh -i ~/.ssh/tf-lab-key ec2-user@${aws_instance.web.public_ip}"
}

output "instance_id" {
  value = aws_instance.web.id
}