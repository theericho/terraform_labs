resource "aws_network_acl" "public" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "tf-public-nacl"
  }
}

# ---------- Inbound ----------
resource "aws_network_acl_rule" "inbound_ssh" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "inbound_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "inbound_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}

# # Inbound UDP ephemeral, for the DNS responses
# resource "aws_network_acl_rule" "inbound_udp_ephemeral" {
#   network_acl_id = aws_network_acl.public.id
#   rule_number    = 130
#   egress         = false
#   protocol       = "udp"
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 1024
#   to_port        = 65535
# }

# ---------- Outbound ----------
resource "aws_network_acl_rule" "outbound_all_tcp" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 65535
}

# # Outbound DNS
# resource "aws_network_acl_rule" "outbound_dns" {
#   network_acl_id = aws_network_acl.public.id
#   rule_number    = 110
#   egress         = true
#   protocol       = "udp"
#   rule_action    = "allow"
#   cidr_block     = "0.0.0.0/0"
#   from_port      = 53
#   to_port        = 53
# }

resource "aws_network_acl_association" "public_one" {
  network_acl_id = aws_network_acl.public.id
  subnet_id      = data.aws_subnet.public_one.id
}