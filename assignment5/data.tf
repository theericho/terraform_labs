data "aws_instance" "web" {
  filter {
    name   = "tag:Name"
    values = ["tf-web-server"]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

# scope the Lambda permission to account
data "aws_caller_identity" "current" {}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_payload.zip"
}