resource "aws_msk_cluster" "kafka" {
  cluster_name           = "tf-kafka-cluster"
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes

  broker_node_group_info {
    instance_type = var.broker_instance_type

    client_subnets = [data.aws_subnet.public_1.id, data.aws_subnet.public_2.id]

    security_groups = [aws_security_group.msk.id]

    storage_info {
      ebs_storage_info {
        volume_size = var.broker_volume_size
      }
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS_PLAINTEXT"
      in_cluster    = true
    }
  }

  tags = {
    Name = "tf-kafka-cluster"
  }
}