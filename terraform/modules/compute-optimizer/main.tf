# This resource enables the AWS Compute Optimizer service for the entire organization.
# It must be applied from the AWS Organizations master/management account.
resource "aws_organizations_aws_service_access_for_organization" "compute_optimizer" {
  service_principal = "compute-optimizer.amazonaws.com"
} 