resource "aws_vpc" "peer" {
  cidr_block           = var.peer_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tf-peer-vpc"
  }
}

resource "aws_subnet" "peer" {
  vpc_id                  = aws_vpc.peer.id
  cidr_block              = var.peer_subnet_cidr
  availability_zone       = var.peer_az
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-peer-subnet-1"
  }
}

# required to SSH into instance-peer

resource "aws_internet_gateway" "peer" {
  vpc_id = aws_vpc.peer.id

  tags = {
    Name = "tf-peer-igw"
  }
}

resource "aws_route_table" "peer" {
  vpc_id = aws_vpc.peer.id

  tags = {
    Name = "tf-peer-rt"
  }
}

resource "aws_route" "peer_igw" {
  route_table_id         = aws_route_table.peer.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.peer.id
}

resource "aws_route_table_association" "peer" {
  subnet_id      = aws_subnet.peer.id
  route_table_id = aws_route_table.peer.id
}