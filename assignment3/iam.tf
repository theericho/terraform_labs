# 1. The role — who is allowed to become it
resource "aws_iam_role" "ec2_s3_read" {
  name = "tf-ec2-s3-read-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "tf-ec2-s3-read-role"
  }
}

# 2. The policy — what the role can do
resource "aws_iam_policy" "s3_readonly" {
  name        = "tf-s3-readonly-policy"
  description = "Read-only access to S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
        ]
        Resource = "arn:aws:s3:::*"
      }
    ]
  })
}

# 3. Bind policy to role
resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role       = aws_iam_role.ec2_s3_read.name
  policy_arn = aws_iam_policy.s3_readonly.arn
}

# 4. The instance profile — the wrapper EC2 requires
resource "aws_iam_instance_profile" "ec2_s3_read" {
  name = "tf-ec2-s3-read-profile"
  role = aws_iam_role.ec2_s3_read.name
}