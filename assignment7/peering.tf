resource "aws_vpc_peering_connection" "main_to_peer" {
  vpc_id      = data.aws_vpc.main.id
  peer_vpc_id = aws_vpc.peer.id
  auto_accept = false

  tags = {
    Name = "tf-vpc-peering"
  }
}

resource "aws_route" "peer_to_main" {
  route_table_id            = aws_route_table.peer.id
  destination_cidr_block    = data.aws_vpc.main.cidr_block # 10.0.0.0/16
  vpc_peering_connection_id = aws_vpc_peering_connection.main_to_peer.id
}

resource "aws_route" "main_to_peer" {
  route_table_id            = data.aws_route_table.main_public.id
  destination_cidr_block    = var.peer_vpc_cidr # 10.1.0.0/16
  vpc_peering_connection_id = aws_vpc_peering_connection.main_to_peer.id
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = aws_vpc_peering_connection.main_to_peer.id
  auto_accept               = true

  tags = {
    Name = "tf-peer-accept"
  }
}