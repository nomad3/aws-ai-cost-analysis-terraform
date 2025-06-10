variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., prod, dev, staging)"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "AWS-Cost-Analysis"
    ManagedBy   = "Terraform"
    Environment = "prod"
  }
}

variable "cost_report_bucket_name" {
  description = "Name of the S3 bucket to store cost reports"
  type        = string
}

variable "notification_email" {
  description = "Email address for cost anomaly notifications"
  type        = string
}

variable "anomaly_detection_threshold_dollars" {
  description = "Dollar threshold for cost anomaly detection."
  type        = number
  default     = 100
} 