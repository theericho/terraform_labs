resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = data.aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  map_public_ip_on_launch = false
  tags = {
    Name = "tf-private-subnet-${count.index + 1}"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "tf-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "tf-db-subnet-group"
  }
}