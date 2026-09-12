resource "aws_key_pair" "lab" {
  key_name   = var.key_name
  public_key = file(pathexpand(var.public_key_path))

  tags = {
    Name = var.key_name
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.public.id
  vpc_security_group_ids = [data.aws_security_group.web.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_s3_read.name
  key_name               = aws_key_pair.lab.key_name

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
  }

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello World from Terraform EC2 $(hostname -f)</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "tf-web-server"
  }
}