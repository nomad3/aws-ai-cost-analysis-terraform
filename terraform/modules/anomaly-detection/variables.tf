variable "environment" {
  description = "Environment name (e.g., prod, dev, staging)"
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

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
} 