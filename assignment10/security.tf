resource "aws_security_group" "mwaa" {
  name        = "tf-mwaa-sg"
  description = "MWAA environment access"
  vpc_id      = aws_vpc.main.id

  egress {
    description = "All outbound- MWAA needs S3, CloudWatch, SQS, package repos"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "tf-mwaa-sg" }
}

# Internal component communication — must be standalone,
# a group can't reference itself inline
resource "aws_vpc_security_group_ingress_rule" "mwaa_self" {
  security_group_id            = aws_security_group.mwaa.id
  referenced_security_group_id = aws_security_group.mwaa.id
  ip_protocol                  = "-1"
  description                  = "All traffic between MWAA components"
}