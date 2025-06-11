terraform {
  required_version = ">= 1.0.0"

  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Project     = "AWS-Cost-Analysis"
      ManagedBy   = "Terraform"
      Environment = "dev"
    }
  }
}

# --- Module Instantiation ---

module "cost_intelligence" {
  source = "../../modules/cost-intelligence"

  # Module Inputs
  environment             = "dev"
  aws_region              = "us-east-1"
  cost_report_bucket_name = "cost-analysis-poc-reports-9f8e7d-dev"
  cost_report_name        = "cost-usage-report-dev"
  tags = {
    "Terraform" = "true"
  }
}

module "anomaly_detection" {
  source = "../../modules/anomaly-detection"

  # Module Inputs
  environment                       = "dev"
  notification_email                = "simon@altvia.com"
  anomaly_monitor_type              = "DIMENSIONAL"
  anomaly_detection_threshold_dollars = 100
  tags = {
    "Terraform" = "true"
  }

  depends_on = [module.cost_intelligence]
}
