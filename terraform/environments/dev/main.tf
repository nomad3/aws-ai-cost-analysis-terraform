terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "cost_analysis" {
  source = "../../" // Points to the root module in terraform/

  environment                       = "dev"
  cost_report_bucket_name           = "cost-analysis-poc-reports-9f8e7d-dev"
  notification_email                = "test@example.com"
  anomaly_detection_threshold_dollars = 100

  default_tags = {
    Environment = "dev"
    Project     = "AWS-Cost-Analysis"
    ManagedBy   = "Terraform"
  }
}
