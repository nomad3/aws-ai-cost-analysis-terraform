#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}AWS Cost Analysis POC Deployment${NC}"
echo "=================================="

# Check AWS CLI configuration
echo -e "\n${GREEN}Checking AWS Configuration...${NC}"
aws sts get-caller-identity
if [ $? -ne 0 ]; then
    echo "Error: AWS CLI not configured. Please run 'aws configure' first."
    exit 1
fi

# Initialize Terraform
echo -e "\n${GREEN}Initializing Terraform...${NC}"
cd terraform/environments/prod
terraform init

# Plan deployment
echo -e "\n${GREEN}Planning Deployment...${NC}"
terraform plan -out=tfplan

# Confirm deployment
echo -e "\n${GREEN}Ready to deploy. Press Enter to continue or Ctrl+C to cancel...${NC}"
read

# Apply configuration
echo -e "\n${GREEN}Deploying Infrastructure...${NC}"
terraform apply tfplan

# Show outputs
echo -e "\n${GREEN}Deployment Complete! Infrastructure Details:${NC}"
terraform output

echo -e "\n${GREEN}Next Steps:${NC}"
echo "1. Check your email for the SNS subscription confirmation"
echo "2. Visit the AWS Console to view the CloudWatch dashboard"
echo "3. Configure QuickSight if you haven't already"
echo "4. Wait 24-48 hours for initial cost data to populate"

echo -e "\n${GREEN}POC Setup Complete!${NC}" 