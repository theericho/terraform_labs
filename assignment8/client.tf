resource "aws_instance" "kafka_client" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnet.public_1.id
  vpc_security_group_ids      = [data.aws_security_group.web.id]
  key_name                    = "tf-lab-key"
  associate_public_ip_address = true

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "tf-kafka-client"
  }
}