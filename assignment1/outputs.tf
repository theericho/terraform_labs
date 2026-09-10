output "vpc_id" {
  description = "ID of VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "ID of the public subnets"
  value       = aws_subnet.public[*].id
  # splat expression (list comprehension)
  # value = [for s in aws_subnet.public : s.id]
}