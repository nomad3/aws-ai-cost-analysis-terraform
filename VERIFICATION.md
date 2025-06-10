# AWS Cost Analysis Platform: Verification Guide

This guide provides a step-by-step checklist to verify that all components deployed by the Terraform configuration are working correctly in your AWS account.

---

### 1. Check the S3 Bucket

This bucket is the destination for your detailed cost reports.

*   **Action:** Navigate to the **S3** service in the AWS Console.
*   **Verify:**
    *   An S3 bucket named `cost-analysis-poc-reports-9f8e7d-dev` exists.
    *   Click on the bucket, go to the **Permissions** tab, and view the **Bucket policy**. It should contain a policy that allows the service principal `billingreports.amazonaws.com` to perform `GetBucketAcl`, `GetBucketPolicy`, and `PutObject` actions.

---

### 2. Check the Cost & Usage Report (CUR)

This is the report definition that tells AWS to generate and deliver the data.

*   **Action:** Navigate to the **Billing and Cost Management** service.
*   **Verify:**
    *   In the left-hand navigation pane, select **Cost & Usage Reports**.
    *   A report named `cost-usage-report-dev` should be present.
    *   Confirm that it is configured for **hourly** time unit, **Parquet** format, and is set to deliver to the `cost-analysis-poc-reports-9f8e7d-dev` S3 bucket.
    *   **Note:** It can take up to **24 hours** for AWS to generate and deliver the first report to your S3 bucket. You will not see data in the bucket immediately.

---

### 3. Check Cost Anomaly Detection

This service monitors your spending for unusual activity.

*   **Action:** Navigate to the **AWS Cost Management** service.
*   **Verify:**
    *   In the left-hand navigation pane, select **Cost Anomaly Detection**.
    *   A monitor named `cost-anomaly-monitor-dev` should be active.
    *   Click on the monitor and check its subscriptions. You should see a subscription configured to send alerts to the `cost-anomaly-alerts-dev` SNS topic when the anomaly total impact is greater than or equal to **$100**.

---

### 4. Check the SNS Subscription

This ensures you will receive email alerts if an anomaly is detected.

*   **Action:** Navigate to the **Simple Notification Service (SNS)**.
*   **Verify:**
    *   In the left-hand navigation pane, select **Topics**.
    *   Find and click on the topic named `cost-anomaly-alerts-dev`.
    *   Under the **Subscriptions** tab, you should see a subscription for the email address `test@example.com`.
    *   The status should be `Confirmed`. If you use a real email address, you must click the confirmation link sent from AWS to activate the subscription.

---

### 5. Check the Athena Workgroup

This is the environment where you will run your cost analysis queries.

*   **Action:** Navigate to the **Amazon Athena** service.
*   **Verify:**
    *   At the top of the Query Editor, check the **Workgroup**. Ensure that `cost-analysis-dev` is available and selected.
    *   The workgroup configuration should specify a query result location pointing to a path inside your `cost-analysis-poc-reports-9f8e7d-dev` S3 bucket.

---

### 6. Query Your Cost Data with Athena (After 24+ Hours)

Once the first CUR report has been delivered to your S3 bucket, you can begin to query the data.

1.  **Create the Table:** AWS automatically creates a data source and table in the AWS Glue Data Catalog. You will need to run a `CREATE TABLE` query one time to get started. You can find the exact query needed in the AWS Console under the **Cost and Usage Reports** settings page for your report.
2.  **Run Sample Queries:** In the Athena Query Editor, you can run queries like the one below. Remember to replace `"your_cur_database"."your_cur_table"` with the actual database and table name from the previous step.

    **Query: Total cost per service for the last month**
    ```sql
    SELECT
      line_item_product_code,
      SUM(line_item_blended_cost) AS total_cost
    FROM
      "your_cur_database"."your_cur_table"
    WHERE
      year = '2024' AND month = '06'
    GROUP BY
      line_item_product_code
    ORDER BY
      total_cost DESC;
    ```

Following these steps will confirm that the system is fully operational. 