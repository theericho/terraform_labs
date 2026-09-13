data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["tf-main-vpc"]
  }
}

# us-east-1a and us-east-1b. MSK requires subnets in multiple AZs
data "aws_subnet" "public_1" {
  filter {
    name   = "tag:Name"
    values = ["tf-public-subnet-1"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_subnet" "public_2" {
  filter {
    name   = "tag:Name"
    values = ["tf-public-subnet-2"]
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