data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["tf-main-vpc"]
  }
}

data "aws_route_table" "main_public" {
  filter {
    name   = "tag:Name"
    values = ["tf-public-rt"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_subnet" "main_public_1" {
  filter {
    name   = "tag:Name"
    values = ["tf-public-subnet-1"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_security_group" "web" {
  filter {
    name   = "group-name"
    values = ["tf-web-sg"]
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}