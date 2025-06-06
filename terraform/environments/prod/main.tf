terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "aws-cost-analysis/prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

module "cost_analysis" {
  source = "../../"

  environment              = "prod"
  aws_region              = "us-east-1"
  cost_report_bucket_name = "your-cost-reports-bucket-prod"
  notification_email      = "your-email@example.com"

  default_tags = {
    Environment = "prod"
    Project     = "AWS-Cost-Analysis"
    ManagedBy   = "Terraform"
  }
} 