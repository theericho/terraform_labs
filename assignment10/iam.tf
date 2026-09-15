locals {
  # Built from account + region rather than referencing the MWAA
  # resource, which would create a dependency cycle.
  mwaa_env_arn = "arn:aws:airflow:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:environment/${var.environment_name}"
}

resource "aws_iam_role" "mwaa" {
  name = "tf-mwaa-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = [
            "airflow.amazonaws.com",
            "airflow-env.amazonaws.com",
          ]
        }
      }
    ]
  })

  tags = { Name = "tf-mwaa-execution-role" }
}

resource "aws_iam_policy" "mwaa" {
  name        = "tf-mwaa-execution-policy"
  description = "Least-privilege permissions for the MWAA environment"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "PublishAirflowMetrics"
        Effect   = "Allow"
        Action   = "airflow:PublishMetrics"
        Resource = local.mwaa_env_arn
      },
      {
        Sid    = "DenyListingAllBuckets"
        Effect = "Deny"
        Action = "s3:ListAllMyBuckets"
        Resource = [
          aws_s3_bucket.dags.arn,
          "${aws_s3_bucket.dags.arn}/*",
        ]
      },
      {
        Sid    = "ReadDagBucket"
        Effect = "Allow"
        Action = [
          "s3:GetObject*",
          "s3:GetBucket*",
          "s3:List*",
        ]
        Resource = [
          aws_s3_bucket.dags.arn,
          "${aws_s3_bucket.dags.arn}/*",
        ]
      },
      {
        Sid    = "WriteAirflowLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:GetLogRecord",
          "logs:GetLogGroupFields",
          "logs:GetQueryResults",
        ]
        Resource = [
          "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:airflow-${var.environment_name}-*",
        ]
      },
      {
        Sid      = "DescribeLogGroups"
        Effect   = "Allow"
        Action   = "logs:DescribeLogGroups"
        Resource = "*"
      },
      {
        Sid      = "PublishCloudWatchMetrics"
        Effect   = "Allow"
        Action   = "cloudwatch:PutMetricData"
        Resource = "*"
      },
      {
        Sid    = "CeleryQueueAccess"
        Effect = "Allow"
        Action = [
          "sqs:ChangeMessageVisibility",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ReceiveMessage",
          "sqs:SendMessage",
        ]
        Resource = "arn:aws:sqs:${data.aws_region.current.region}:*:airflow-celery-*"
      },
      {
        Sid    = "KmsForAirflowManagedKeys"
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey*",
          "kms:Encrypt",
        ]
        NotResource = "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*"
        Condition = {
          StringLike = {
            "kms:ViaService" = [
              "sqs.${data.aws_region.current.region}.amazonaws.com",
              "s3.${data.aws_region.current.region}.amazonaws.com",
            ]
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "mwaa" {
  role       = aws_iam_role.mwaa.name
  policy_arn = aws_iam_policy.mwaa.arn
}