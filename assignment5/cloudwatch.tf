resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "tf-cpu-high-alarm"
  alarm_description   = "Alarm when CPU exceeds 50% for 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 50

  dimensions = {
    InstanceId = data.aws_instance.web.id
  }

  alarm_actions = [aws_lambda_function.cpu_alarm_logger.arn]

  treat_missing_data = "notBreaching"

  tags = {
    Name = "tf-cpu-high-alarm"
  }
}