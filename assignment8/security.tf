resource "aws_security_group" "msk" {
  name        = "tf-msk-sg"
  description = "Kafka broker access"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description     = "Kafka plaintext from web tier"
    from_port       = 9092
    to_port         = 9092
    protocol        = "tcp"
    security_groups = [data.aws_security_group.web.id]
  }

  ingress {
    description     = "Kafka TLS from the web tier"
    from_port       = 9094
    to_port         = 9094
    protocol        = "tcp"
    security_groups = [data.aws_security_group.web.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-msk-sg"
  }
}

# broker-to-broker, traffic within tf-msk-sg
# group can't reference its own ID inline, so needs seperate resource
resource "aws_vpc_security_group_ingress_rule" "msk_self" {
  security_group_id            = aws_security_group.msk.id
  referenced_security_group_id = aws_security_group.msk.id
  ip_protocol                  = "-1"
  description                  = "All traffic between brokers"
}