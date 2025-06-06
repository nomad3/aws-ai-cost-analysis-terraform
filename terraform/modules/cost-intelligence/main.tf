resource "aws_s3_bucket" "cost_reports" {
  bucket = var.cost_report_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "cost_reports" {
  bucket = aws_s3_bucket.cost_reports.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cost_reports" {
  bucket = aws_s3_bucket.cost_reports.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_cur_report_definition" "cost_usage_report" {
  report_name                = "cost-usage-report-${var.environment}"
  time_unit                  = "HOURLY"
  format                     = "Parquet"
  compression               = "Parquet"
  additional_schema_elements = ["RESOURCES"]
  s3_bucket                 = aws_s3_bucket.cost_reports.id
  s3_region                 = var.aws_region
  report_versioning         = "OVERWRITE_REPORT"

  depends_on = [aws_s3_bucket.cost_reports]
}

# Athena Workgroup for cost analysis
resource "aws_athena_workgroup" "cost_analysis" {
  name = "cost-analysis-${var.environment}"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.cost_reports.bucket}/athena-results/"
      
      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }
} 