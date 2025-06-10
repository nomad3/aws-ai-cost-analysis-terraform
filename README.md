# AWS AI-Powered Cost Analysis Platform

This repository contains a modular Terraform configuration to deploy a foundational AWS cost analysis platform. It sets up automated Cost and Usage Reports (CUR), cost anomaly detection with alerts, and the necessary data backend for analysis with Amazon Athena.

## Core Features

- **Automated Cost & Usage Reports (CUR):** Deploys a CUR definition to deliver detailed, hourly billing data in Parquet format to an S3 bucket.
- **Cost Anomaly Detection:** Configures AWS Cost Anomaly Detection to monitor service spending and sends an alert via SNS if costs exceed a defined daily threshold.
- **Query-Ready Backend:** Creates an S3 bucket for reports and an Athena workgroup, preparing the environment for cost analysis queries.
- **Modular & Multi-Environment:** Designed with a modular structure and environment-specific configurations (`dev`, `prod`, etc.).

## Architecture

At a high level, this system a
utomates the collection and monitoring of your AWS cost data.

### Deployment Flow

Terraform is used to read the configuration and deploy all the necessary resources into your AWS account.

```mermaid
graph TD;
    subgraph "Your Laptop"
        A[You run 'terraform apply'];
    end

    subgraph "Terraform Cloud/Core"
        B[Terraform reads .tf files];
        C[Terraform sends instructions to AWS];
    end

    subgraph "AWS Cloud"
        D[S3 Bucket];
        E[Cost & Usage Report];
        F[Cost Anomaly Monitor];
        G[SNS Topic];
        H[Athena Workgroup];
    end

    A --> B;
    B --> C;
    C --> D;
    C --> E;
    C --> F;
    C --> G;
    C --> H;

    style D fill:#FF9900,stroke:#333,stroke-width:2px;
    style E fill:#FF9900,stroke:#333,stroke-width:2px;
    style F fill:#FF9900,stroke:#333,stroke-width:2px;
    style G fill:#FF9900,stroke:#333,stroke-width:2px;
    style H fill:#FF9900,stroke:#333,stroke-width:2px;
end
```

### Data & Alerting Flow

Once deployed, this automated workflow begins. It collects your cost data and watches for spending anomalies.

```mermaid
graph TD;
    subgraph "AWS Services"
        A["EC2, RDS, etc."];
    end

    subgraph "Cost Management Services"
        B["Cost & Usage Report (CUR) Service"];
        C["Cost Anomaly Detection Service"];
    end

    subgraph "Data & Alerting"
        D["S3 Bucket"];
        E["SNS Topic"];
        F["Your Email"];
    end
    
    subgraph "Analysis"
        G["Athena"];
    end

    A --> B;
    B --"Hourly Parquet Files"--> D;
    A --> C;
    C --"If anomaly > $100"--> E;
    E --"Email Alert"--> F;
    G --"SQL Queries"--> D;

    style D fill:#227F4B,stroke:#333,stroke-width:2px;
    style G fill:#227F4B,stroke:#333,stroke-width:2px;
    style E fill:#D92528,stroke:#333,stroke-width:2px;
end
```

## Getting Started: Local `dev` Deployment

These steps will guide you through deploying the `dev` environment using a local Terraform state file.

### Prerequisites

1.  **Terraform >= 1.0.0:** [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2.  **AWS CLI >= 2.0:** [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
3.  **AWS Credentials:** You must have AWS credentials configured. The recommended way is to get temporary credentials from the AWS SSO portal and export them as environment variables:
    ```bash
    export AWS_ACCESS_KEY_ID="<your_access_key>"
    export AWS_SECRET_ACCESS_KEY="<your_secret_key>"
    export AWS_SESSION_TOKEN="<your_session_token>"
    ```

### Deployment Steps

1.  **Clone the repository.**

2.  **Navigate to the `dev` environment directory:**
    ```bash
    cd aws-ai-cost-analysis-terraform/terraform/environments/dev
    ```

3.  **Initialize Terraform:**
    This command downloads the necessary provider plugins.
    ```bash
    terraform init
    ```

4.  **Plan the deployment:**
    This command shows you what resources will be created without making any changes.
    ```bash
    terraform plan
    ```

5.  **Apply the configuration:**
    This command will create the resources in your AWS account. It will ask for confirmation.
    ```bash
    terraform apply
    ```

## Verification Checklist (Post-Deployment)

After a successful `apply`, check the following in your AWS Console to ensure everything is working.

*   **S3 Bucket:** Navigate to the S3 service. A bucket named `cost-analysis-poc-reports-9f8e7d-dev` should exist with a bucket policy allowing access to `billingreports.amazonaws.com`.
*   **Cost & Usage Reports:** In the Billing and Cost Management service, find "Cost & Usage Reports". A report named `cost-usage-report-dev` should be present.
*   **Cost Anomaly Detection:** In the Cost Management service, under "Cost Anomaly Detection", a monitor named `cost-anomaly-monitor-dev` should be active.
*   **SNS Subscription:** In the SNS service, find the topic `cost-anomaly-alerts-dev`. Go to subscriptions and confirm your email subscription. You must click the confirmation link sent to your email.
*   **Athena Workgroup:** In the Athena service, ensure the `cost-analysis-dev` workgroup is available.

**Note:** It can take up to 24 hours for AWS to generate and deliver the first CUR report to your S3 bucket.

## Querying Your Cost Data with Athena

Once reports are being delivered, you can query them using Athena.

1.  **Data Source & Table:** AWS automatically creates a data source and table in the Glue Data Catalog. You'll need to run a `CREATE TABLE` query one time to get started. The exact query can be found in the AWS Console under the Cost and Usage Reports settings page.
2.  **Sample Queries:** Here are some example queries you can run in the Athena Query Editor under the `cost-analysis-dev` workgroup.

    **Query: Total cost per service for the last month**
    ```sql
    SELECT
      line_item_product_code,
      SUM(line_item_blended_cost) AS total_cost
    FROM
      "your_cur_database"."your_cur_table"
    WHERE
      year = 'YYYY' AND month = 'MM'
    GROUP BY
      line_item_product_code
    ORDER BY
      total_cost DESC;
    ```

    **Query: Daily EC2 costs for the current month**
    ```sql
    SELECT
      line_item_usage_start_date,
      SUM(line_item_blended_cost) AS daily_cost
    FROM
      "your_cur_database"."your_cur_table"
    WHERE
      line_item_product_code = 'AmazonEC2'
      AND year = 'YYYY' AND month = 'MM'
    GROUP BY
      line_item_usage_start_date
    ORDER BY
      line_item_usage_start_date;
    ```

## Moving to a Production Setup (S3 Backend)

For team collaboration and production use, you should use an S3 backend for Terraform state.

1.  **Create Backend Resources:** Create a globally unique S3 bucket and a DynamoDB table for state locking.
2.  **Update Configuration:** Uncomment the `backend "s3"` block in `terraform/environments/dev/main.tf` and provide your bucket and table names.
3.  **Re-initialize:** Run `terraform init -migrate-state`. Terraform will detect the local state file and prompt you to copy it to the new S3 backend, centralizing your state management. 