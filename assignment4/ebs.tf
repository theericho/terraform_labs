resource "aws_ebs_volume" "extra_data" {
  availability_zone = data.aws_instance.web.availability_zone
  size              = 1
  type              = "gp2"
  encrypted         = true

  tags = {
    Name = "tf-extra-data-volume"
  }
}

resource "aws_volume_attachment" "extra_data" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.extra_data.id
  instance_id = data.aws_instance.web.id
}