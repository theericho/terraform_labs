# Look up VPC created in Assignment 1, by its Name tag
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

# All public subnets in that VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = ["tf-public-subnet-*"]
  }
}

# The first subnet specifically, looked up by exact name
# Used for NACL association so we get a deterministic target
data "aws_subnet" "public_one" {
  filter {
    name   = "tag:Name"
    values = ["tf-public-subnet-1"]
  }
}

# terraform plan -> gets current public IP, but access changes if public IP or location changes
# alternatively, export TF_VAR_my_ip="$(curl -s https://checkip.amazonaws.com)/32" in CLI
# pass in IPs as env variables, but below is ok for local/single developer use

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

locals {
  my_ip = "${chomp(data.http.my_ip.response_body)}/32"
}