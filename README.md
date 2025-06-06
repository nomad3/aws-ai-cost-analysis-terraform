# AWS Cost Analysis Infrastructure

This repository contains Terraform configurations for setting up AWS cost analysis and optimization infrastructure.

## Features

- Cost and Usage Reports (CUR) setup with Athena integration
- Cost anomaly detection with email notifications
- AWS Compute Optimizer integration
- Multi-environment support
- Modular design

## Prerequisites

- Terraform >= 1.0.0
- AWS CLI configured with appropriate permissions
- S3 bucket for Terraform state
- DynamoDB table for state locking

## Module Structure

```
aws-cost-analysis/
├── terraform/
│   ├── modules/
│   │   ├── cost-intelligence/    # CUR and Athena setup
│   │   ├── anomaly-detection/    # Cost anomaly monitoring
│   │   └── compute-optimizer/    # Resource optimization
│   └── environments/
│       ├── prod/                 # Production environment
│       └── dev/                  # Development environment
```

## Usage

1. Configure your AWS credentials:
```bash
aws configure
```

2. Update the environment configuration:
Edit `terraform/environments/[env]/main.tf` with your specific values:
- S3 bucket names
- AWS region
- Notification email
- Tags

3. Initialize Terraform:
```bash
cd terraform/environments/[env]
terraform init
```

4. Apply the configuration:
```bash
terraform plan
terraform apply
```

## Modules

### Cost Intelligence
- Sets up Cost and Usage Reports
- Configures Athena for cost analysis
- Creates S3 bucket for reports

### Anomaly Detection
- Configures cost anomaly detection
- Sets up SNS notifications
- Defines monitoring thresholds

### Compute Optimizer
- Enables AWS Compute Optimizer
- Configures optimization preferences

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| environment | Environment name | string | - |
| aws_region | AWS region | string | us-east-1 |
| cost_report_bucket_name | S3 bucket for reports | string | - |
| notification_email | Alert email | string | - |
| anomaly_detection_threshold | Alert threshold % | number | 10 |

## Outputs

- Cost report bucket details
- Athena workgroup information
- SNS topic ARN for notifications

## Security

- S3 buckets are encrypted
- SNS topics have proper access policies
- All resources are tagged

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request