# SNS Topic for Cost Alerts
resource "aws_sns_topic" "billing_alerts" {
  name = "billing-alerts-topic"
}

# SNS Subscription for Email Alerts
resource "aws_sns_topic_subscription" "billing_email_sub" {
  topic_arn = aws_sns_topic.billing_alerts.arn
  protocol  = "email"
  endpoint  = var.email_id
}

# AWS Budget for Monthly Cost Limit
resource "aws_budgets_budget" "monthly_budget_stream" {
  name              = "Monthly-Budget"
  budget_type       = "COST"
  limit_amount      = var.amount_limit
  limit_unit        = "USD"
  time_unit        = "MONTHLY"
  cost_filter = {
    name = "TagKeyValue"
    values = [
      "aws:Project$LiveStreamingApp"
    ]
  }

  notification {
    comparison_operator       = "GREATER_THAN"
    threshold                = var.budget_threshold
    threshold_type           = "PERCENTAGE"
    notification_type        = "ACTUAL"
    subscriber_sns_topic_arns = [aws_sns_topic.billing_alerts.arn]
  }
}
