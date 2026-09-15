resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "dags" {
  bucket        = "tf-mwaa-dags-bucket-${random_string.suffix.result}"
  force_destroy = true # lab only

  tags = { Name = "tf-mwaa-dags-bucket" }
}

resource "aws_s3_bucket_versioning" "dags" {
  bucket = aws_s3_bucket.dags.id

  versioning_configuration {
    status = "Enabled"
  }
}

# REQUIRED by MWAA — the environment will not create without this
resource "aws_s3_bucket_public_access_block" "dags" {
  bucket = aws_s3_bucket.dags.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# "Folders" — zero-byte objects with trailing slashes
resource "aws_s3_object" "dags_folder" {
  bucket = aws_s3_bucket.dags.id
  key    = "dags/"
}

resource "aws_s3_object" "plugins_folder" {
  bucket = aws_s3_bucket.dags.id
  key    = "plugins/"
}

# Upload the sample DAG straight from the repo
resource "aws_s3_object" "hello_world_dag" {
  bucket = aws_s3_bucket.dags.id
  key    = "dags/hello_world_dag.py"
  source = "${path.module}/dags/hello_world_dag.py"
  etag   = filemd5("${path.module}/dags/hello_world_dag.py")
}