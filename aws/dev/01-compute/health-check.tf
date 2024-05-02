resource "aws_route53_health_check" "ss_health_check" {
  fqdn              = "dev.server.cloud"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/login"
  failure_threshold = "3"
  request_interval  = "30"
  regions = ["us-east-1", "us-west-1", "us-west-2"]

  tags = {
    Name = "Server HealthCheck1"
  }
}

resource "aws_cloudwatch_metric_alarm" "health_check_alarm" {
  alarm_name                = "health-check-status-alarm"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "HealthCheckStatus"
  namespace                 = "AWS/Route53"
  period                    = "60"  # 1 minute
  statistic                 = "Minimum"
  threshold                 = "1"
  alarm_description         = "This metric monitors the health check status"
  actions_enabled           = true
  alarm_actions             = [aws_sns_topic.HealthCheckSNSTopic.arn]
  dimensions = {
    HealthCheckId = aws_route53_health_check.ss_health_check.id
  }
}

resource "aws_sns_topic" "HealthCheckSNSTopic" {
  name = "HealthCheckSNSTopic1"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.HealthCheckSNSTopic.arn
  protocol  = "email"
  endpoint  = "admin@company.ai"
}
