output "cost_report_bucket_name" {
  description = "Name of the S3 bucket storing cost reports"
  value       = aws_s3_bucket.cost_reports.id
}

output "cost_report_bucket_arn" {
  description = "ARN of the S3 bucket storing cost reports"
  value       = aws_s3_bucket.cost_reports.arn
}

output "athena_workgroup_name" {
  description = "Name of the Athena workgroup for cost analysis"
  value       = aws_athena_workgroup.cost_analysis.name
} 