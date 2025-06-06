module "cost_intelligence" {
  source = "./modules/cost-intelligence"

  environment            = var.environment
  aws_region            = var.aws_region
  cost_report_bucket_name = var.cost_report_bucket_name
  tags                  = var.default_tags
}

module "anomaly_detection" {
  source = "./modules/anomaly-detection"

  environment                 = var.environment
  notification_email         = var.notification_email
  anomaly_detection_threshold = var.anomaly_detection_threshold
  tags                       = var.default_tags

  depends_on = [module.cost_intelligence]
}

module "compute_optimizer" {
  source = "./modules/compute-optimizer"

  environment = var.environment
  tags        = var.default_tags

  depends_on = [module.cost_intelligence]
} 