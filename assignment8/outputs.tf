output "msk_cluster_arn" {
  description = "ARN of the MSK cluster"
  value       = aws_msk_cluster.kafka.arn
}

output "zookeeper_connect_string" {
  description = "ZooKeeper connection string (empty on KRaft clusters)"
  value       = aws_msk_cluster.kafka.zookeeper_connect_string
}

output "bootstrap_brokers_plaintext" {
  description = "Plaintext broker endpoints, port 9092"
  value       = aws_msk_cluster.kafka.bootstrap_brokers
}

output "bootstrap_brokers_tls" {
  description = "TLS broker endpoints, port 9094"
  value       = aws_msk_cluster.kafka.bootstrap_brokers_tls
}

output "msk_security_group_id" {
  value = aws_security_group.msk.id
}

# Test client
output "client_public_ip" {
  value = aws_instance.kafka_client.public_ip
}

output "client_ssh_command" {
  value = "ssh -i ~/.ssh/tf-lab-key ec2-user@${aws_instance.kafka_client.public_ip}"
}