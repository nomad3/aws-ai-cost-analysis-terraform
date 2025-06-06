resource "aws_compute_optimizer_recommendation_export" "export" {
  s3_destination_config {
    bucket = var.cost_report_bucket_name
    key_prefix = "compute-optimizer/${var.environment}"
  }

  recommendations_export_config {
    name = "compute-optimizer-export-${var.environment}"
    
    include {
      fields = ["AccountId", "Finding", "InstanceName", "InstanceType", "AllInstanceTypes", "AllUpfrontCosts", "OnDemandPrice"]
    }
  }
}

# Enable Compute Optimizer
resource "aws_organizations_organization_settings" "compute_optimizer" {
  compute_optimizer_access = "OPT_IN_MODE"
}

# CloudWatch Dashboard for cost optimization insights
resource "aws_cloudwatch_dashboard" "cost_optimization" {
  dashboard_name = "cost-optimization-${var.environment}"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ComputeOptimizer", "OptimizationScore", "ResourceType", "Ec2Instance"]
          ]
          period = 86400
          stat   = "Average"
          region = var.aws_region
          title  = "EC2 Optimization Score"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/CostExplorer", "TotalCost", "Service", "AmazonEC2"]
          ]
          period = 86400
          stat   = "Sum"
          region = var.aws_region
          title  = "EC2 Daily Cost"
        }
      }
    ]
  })
} 