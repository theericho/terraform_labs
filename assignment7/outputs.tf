output "vpc_peering_id" {
  description = "ID of the peering connection"
  value       = aws_vpc_peering_connection.main_to_peer.id
}

output "peer_vpc_id" {
  description = "ID of the second VPC"
  value       = aws_vpc.peer.id
}

output "peering_status" {
  description = "Should be 'active' after acceptance"
  value       = aws_vpc_peering_connection_accepter.peer.accept_status
}

# Test instances
output "instance_main_public_ip" {
  value = aws_instance.main.public_ip
}

output "instance_main_private_ip" {
  value = aws_instance.main.private_ip
}

output "instance_peer_public_ip" {
  value = aws_instance.peer.public_ip
}

output "instance_peer_private_ip" {
  value = aws_instance.peer.private_ip
}

output "ping_from_main" {
  description = "Run this on instance-main"
  value       = "ping -c 4 ${aws_instance.peer.private_ip}"
}

output "ping_from_peer" {
  description = "Run this on instance-peer"
  value       = "ping -c 4 ${aws_instance.main.private_ip}"
}