variable "environment" {
  description = "Environment name (e.g., prod, dev, staging)"
  type        = string
}

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
}

variable "cost_report_bucket_name" {
  description = "Name of the S3 bucket to store cost reports"
  type        = string
}

variable "cost_report_name" {
  description = "The name for the Cost and Usage Report."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
} 