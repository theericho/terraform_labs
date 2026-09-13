# create log group explicitly to control retention
# lambda would otherwise create it with retention = never expire
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/tf-cpu-alarm-logger"
  retention_in_days = 7

  tags = {
    Name = "tf-cpu-alarm-logger-logs"
  }
}

resource "aws_lambda_function" "cpu_alarm_logger" {
  function_name = "tf-cpu-alarm-logger"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.13"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  memory_size      = 128
  timeout          = 30

  environment {
    variables = {
      INSTANCE_ID = data.aws_instance.web.id
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic,
    aws_cloudwatch_log_group.lambda
  ]

  tags = {
    Name = "tf-cpu-alarm-logger"
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_alarm" {
  statement_id   = "AllowExecutionFromCloudWatchAlarm"
  action         = "lambda:InvokeFunction"
  function_name  = aws_lambda_function.cpu_alarm_logger.function_name
  principal      = "lambda.alarms.cloudwatch.amazonaws.com"
  source_arn     = aws_cloudwatch_metric_alarm.cpu_high.arn
  source_account = data.aws_caller_identity.current.account_id
}