data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["tf-main-vpc"]
  }
}

data "aws_security_group" "web" {
  filter {
    name   = "group-name"
    values = ["tf-web-sg"]
  }
  # filter on vpc id for security group, as group names are only unique per VPC
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}