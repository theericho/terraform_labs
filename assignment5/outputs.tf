output "cw_alarm_name" {
  description = "Name of the CloudWatch alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_high.alarm_name
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.cpu_alarm_logger.function_name
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.lambda.name
}

output "monitored_instance_id" {
  value = data.aws_instance.web.id
}

output "alarm_arn" {
  value = aws_cloudwatch_metric_alarm.cpu_high.arn
}