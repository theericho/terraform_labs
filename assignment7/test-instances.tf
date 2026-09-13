# --- Security group for the peer VPC instance ---

resource "aws_security_group" "peer" {
  name        = "tf-peer-sg"
  description = "SSH from my IP, ICMP from the main VPC"
  vpc_id      = aws_vpc.peer.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "ICMP from the main VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description = "SSH from the main VPC (for jump-host access over peering)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-peer-sg"
  }
}

# --- Instances ---

resource "aws_instance" "main" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t3.micro"
  subnet_id                   = data.aws_subnet.main_public_1.id
  vpc_security_group_ids      = [data.aws_security_group.web.id]
  key_name                    = "tf-lab-key"
  associate_public_ip_address = true

  credit_specification {
    cpu_credits = "standard"
  }

  tags = {
    Name = "instance-main"
  }
}

resource "aws_instance" "peer" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.peer.id
  vpc_security_group_ids = [aws_security_group.peer.id]
  key_name               = "tf-lab-key"

  credit_specification {
    cpu_credits = "standard"
  }

  tags = {
    Name = "instance-peer"
  }
}