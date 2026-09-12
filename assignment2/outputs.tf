output "web_sg_id" {
  description = "ID of the web security group"
  value       = aws_security_group.web.id
}

output "public_nacl_id" {
  description = "ID of the custom public NACL"
  value       = aws_network_acl.public.id
}

# Confirms the data source lookups resolved correctly
output "vpc_id" {
  description = "ID of the referenced VPC"
  value       = data.aws_vpc.main.id
}

output "nacl_associated_subnet" {
  description = "Subnet associated with the custom NACL"
  value       = data.aws_subnet.public_one.id
}