resource "aws_mwaa_environment" "main" {
  name               = var.environment_name
  airflow_version    = var.airflow_version
  environment_class  = var.environment_class
  execution_role_arn = aws_iam_role.mwaa.arn

  source_bucket_arn = aws_s3_bucket.dags.arn
  dag_s3_path       = "dags"

  webserver_access_mode = "PUBLIC_ONLY"

  network_configuration {
    security_group_ids = [aws_security_group.mwaa.id]
    subnet_ids         = aws_subnet.private[*].id
  }

  logging_configuration {
    dag_processing_logs {
      enabled   = true
      log_level = "INFO"
    }
    scheduler_logs {
      enabled   = true
      log_level = "INFO"
    }
    task_logs {
      enabled   = true
      log_level = "INFO"
    }
    webserver_logs {
      enabled   = true
      log_level = "INFO"
    }
    worker_logs {
      enabled   = true
      log_level = "INFO"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.mwaa,
    aws_s3_object.dags_folder,
    aws_nat_gateway.main,
    aws_route.private_nat,
  ]

  tags = { Name = var.environment_name }
}