# s3 bucket names are globally unique
resource "random_pet" "suffix" {
  length    = 2
  separator = "-"
}

resource "aws_s3_bucket" "app_data" {
  count  = 2
  bucket = "tf-app-data-bucket-${random_pet.suffix.id}-${count.index}"

  # allow destroy of non-empty bucket
  force_destroy = true

  tags = {
    Name = "tf-app-data-bucket-${count.index}"
  }
}

resource "aws_s3_bucket_versioning" "app_data" {
  count = 2

  bucket = aws_s3_bucket.app_data[count.index].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "app_data" {
  count = 2

  bucket = aws_s3_bucket.app_data[count.index].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}