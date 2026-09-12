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