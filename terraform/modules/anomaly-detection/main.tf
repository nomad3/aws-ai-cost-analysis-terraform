resource "aws_sns_topic" "cost_anomaly_alerts" {
  name = "cost-anomaly-alerts-${var.environment}"
}

resource "aws_sns_topic_policy" "cost_anomaly_alerts" {
  arn = aws_sns_topic.cost_anomaly_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCEToPublishToCostAnomalyAlerts"
        Effect = "Allow"
        Principal = {
          Service = "costalerts.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.cost_anomaly_alerts.arn
      }
    ]
  })
}

resource "aws_sns_topic_subscription" "cost_anomaly_email" {
  topic_arn = aws_sns_topic.cost_anomaly_alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_ce_anomaly_monitor" "cost_anomaly_monitor" {
  name          = "cost-anomaly-monitor-${var.environment}"
  monitor_type  = var.anomaly_monitor_type
  monitor_dimension = "SERVICE"
}

resource "aws_ce_anomaly_subscription" "cost_anomaly_subscription" {
  name             = "cost-anomaly-subscription-${var.environment}"
  frequency        = "IMMEDIATE"
  monitor_arn_list = [aws_ce_anomaly_monitor.cost_anomaly_monitor.arn]

  subscriber {
    type    = "SNS"
    address = aws_sns_topic.cost_anomaly_alerts.arn
  }

  threshold_expression {
    dimension {
      key           = "ANOMALY_TOTAL_IMPACT_ABSOLUTE"
      match_options = ["GREATER_THAN_OR_EQUAL"]
      values        = [tostring(var.anomaly_detection_threshold_dollars)]
    }
  }
} 