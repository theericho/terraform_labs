resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tf-main-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tf-main-igw"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "tf-public-subnet-${count.index + 1}"
  }
}

# for_each is usually preferred, because count keys resources by position
# resource "aws_subnet" "public" {
#   for_each = {
#     for idx, cidr in var.public_subnet_cidrs : idx => {
#       cidr = cidr
#       az   = var.availability_zones[idx]
#     }
#   }

#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = each.value.cidr
#   availability_zone       = each.value.az
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "tf-public-subnet-${each.key + 1}"
#   }
# }

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "tf-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}