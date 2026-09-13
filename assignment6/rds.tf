resource "aws_db_instance" "app" {
  identifier        = "tf-app-database"
  engine            = "mysql"
  engine_version    = "8.4"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  publicly_accessible    = false
  multi_az               = false

  # For easy cleanup, but not for prod
  # By default, deleting an RDS instance requires a final snapshot
  skip_final_snapshot     = true
  backup_retention_period = 0

  tags = {
    Name = "tf-app-database"
  }
}