# -----------------------------------------------
# Application and Environment Variables
# -----------------------------------------------
variable "application" {
  type        = string
  description = "application name to refer and mnark across the module"
  default     = "di-insights-api"
}

variable "environment" {
  type        = string
  description = "environment type"
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod", "uat"], var.environment)
    error_message = "Environment must be one of: dev, prod, or uat."
  }
}

variable "region" {
  type        = string
  description = "aws region to use"
  default     = "ap-south-1"
}

variable "certificate_domain_name" {
  type        = string
  description = "domain name of the acm certificate for https"
  default     = "*.credeau.com"
}

variable "stack_owner" {
  type        = string
  description = "owner of the stack"
  default     = "tech@credeau.com"
}

variable "stack_team" {
  type        = string
  description = "team of the stack"
  default     = "devops"
}

variable "organization" {
  type        = string
  description = "organization name"
  default     = "credeau"
}

variable "alert_email_recipients" {
  type        = list(string)
  description = "email recipients for sns alerts"
  default     = []
}

# -----------------------------------------------
# Server & Scaling Variables
# -----------------------------------------------

variable "instance_type" {
  type        = string
  description = "Instances type to provision in ASG for insights api"
  default     = "t2.micro"
}

variable "ecr_repository" {
  type        = string
  description = "aws sync ecr repository"
  default     = "device-insights-insights-api"
}

variable "ecr_image_tag" {
  type        = string
  description = "aws sync ecr repository image tag"
  default     = "latest"
}

variable "root_volume_size" {
  type        = number
  description = "size of root volume in GiB"
  default     = 20
}

variable "ami_id" {
  type        = string
  description = "ami to use for instances"
}

variable "key_name" {
  type        = string
  description = "ssh access key name"
}

variable "asg_min_size" {
  type        = number
  description = "minimum number of instances to keep in asg for insights api"
  default     = 1
}

variable "asg_max_size" {
  type        = number
  description = "maximum number of instances to keep in asg for insights api"
  default     = 2
}

variable "asg_desired_size" {
  type        = number
  description = "number of instances to provision for insights api"
  default     = 1
}

variable "upscale_evaluation_period" {
  type        = number
  description = "Number of seconds required to observe the system before triggering upscale"
  default     = 60

  validation {
    condition     = var.upscale_evaluation_period == 10 || var.upscale_evaluation_period == 30 || var.upscale_evaluation_period % 60 == 0
    error_message = "Scaling evaluation period can only be 10, 30 or any multiple of 60."
  }
}

variable "downscale_evaluation_period" {
  type        = number
  description = "Number of seconds required to observe the system before triggering downscale"
  default     = 300

  validation {
    condition     = var.downscale_evaluation_period == 10 || var.downscale_evaluation_period == 30 || var.downscale_evaluation_period % 60 == 0
    error_message = "Scaling evaluation period can only be 10, 30 or any multiple of 60."
  }
}

variable "logs_retention_period" {
  type        = number
  description = "No of days to retain the logs"
  default     = 7
}

variable "api_timeout" {
  type        = number
  description = "api timeout"
  default     = 60
}

variable "scaling_cpu_threshold" {
  type        = number
  description = "CPU utilization % threshold for scaling & alerting"
  default     = 65
}

variable "scaling_memory_threshold" {
  type        = number
  description = "Memory utilization % threshold for scaling & alerting"
  default     = 60
}

variable "scaling_disk_threshold" {
  type        = number
  description = "Disk utilization % threshold for scaling & alerting"
  default     = 80
}

variable "mapped_port" {
  type        = number
  description = "mapped port to expose the application"
  default     = 8000
}

variable "application_port" {
  type        = number
  description = "application port to run the application"
  default     = 8000
}

variable "enable_scheduled_scaling" {
  type        = bool
  description = "enable scheduled scaling"
  default     = false
}

variable "timezone" {
  type        = string
  description = "timezone to use for scheduled scaling"
  default     = "Asia/Kolkata"
}

variable "upscale_schedule" {
  type        = string
  description = "upscale schedule"
  default     = "0 8 * * MON-SUN"
}

variable "scheduled_upscale_min_size" {
  type        = number
  description = "minimum number of instances to keep in asg for scheduled upscale"
  default     = 5
}

variable "scheduled_upscale_max_size" {
  type        = number
  description = "maximum number of instances to keep in asg for scheduled upscale"
  default     = 10
}

variable "scheduled_upscale_desired_size" {
  type        = number
  description = "desired number of instances to keep in asg for scheduled upscale"
  default     = 5
}

variable "downscale_schedule" {
  type        = string
  description = "downscale schedule"
  default     = "0 21 * * MON-SUN"
}

variable "enable_alb_access_logs" {
  type        = bool
  description = "enable alb access logs"
  default     = false
}

# -----------------------------------------------
# Network & Security Variables
# -----------------------------------------------

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "list of private subnet ids to use"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "list of public subnet ids to use"
}

variable "internal_security_groups" {
  type        = list(string)
  description = "list of internal access security group ids"
  default     = []
}

variable "external_security_groups" {
  type        = list(string)
  description = "list of external access security group ids"
  default     = []
}

variable "waf_rate_limit" {
  type        = number
  description = "number of requests to allow from same IP in 1 min span on LB"
  default     = 100
}

variable "allowed_ips" {
  type        = list(string)
  description = "list of allowed ips"
  default     = []
}

variable "use_public_endpoint" {
  type        = bool
  description = "use public endpoint"
  default     = true
}

# -----------------------------------------------
# External Dependencies Variables
# -----------------------------------------------

variable "postgres_user_name" {
  type        = string
  description = "postgres user name"
  default     = null
}

variable "postgres_password" {
  type        = string
  description = "postgres user password"
  default     = null
}

variable "postgres_host" {
  type        = string
  description = "postgres host"
  default     = null
}

variable "postgres_port" {
  type        = number
  description = "postgres port"
  default     = 5432
}

variable "postgres_db" {
  type        = string
  description = "postgres main database"
  default     = null
}

variable "postgres_sync_db" {
  type        = string
  description = "postgres sync database"
  default     = null
}


variable "mongo_username" {
  type        = string
  description = "mongo username"
  default     = null
}

variable "mongo_password" {
  type        = string
  description = "mongo password"
  default     = null
}

variable "mongo_host" {
  type        = string
  description = "mongo host"
  default     = null
}

variable "mongo_port" {
  type        = string
  description = "mongo port"
  default     = 27017
}

variable "mongo_db" {
  type        = string
  description = "mongo database"
  default     = null
}

variable "mongo_enabled_sources" {
  type        = string
  description = "mongo enabled sources"
  default     = "*"
}

variable "mongo_max_pool_size" {
  type        = number
  description = "mongo max pool size"
  default     = 40
}

variable "mongo_min_pool_size" {
  type        = number
  description = "mongo min pool size"
  default     = 2
}

variable "mongo_server_selection_timeout_ms" {
  type        = number
  description = "mongo server selection timeout"
  default     = 30000
}

variable "mongo_connect_timeout_ms" {
  type        = number
  description = "mongo connect timeout"
  default     = 30000
}

variable "mongo_socket_timeout_ms" {
  type        = number
  description = "mongo socket timeout"
  default     = 30000
}

variable "mongo_retry_writes" {
  type        = bool
  description = "mongo retry writes"
  default     = true
}

variable "mongo_wait_queue_timeout_ms" {
  type        = number
  description = "mongo wait queue timeout"
  default     = 5000
}

variable "sms_extractor_host" {
  type        = string
  description = "sms extractor host"
  default     = null
}

variable "sms_extractor_batch_size" {
  type        = number
  description = "sms extractor batch size"
  default     = 1000
}

variable "apps_mapping_path" {
  type        = string
  description = "S3 path to apps mapping config"
}

variable "avg_device_mapping_path" {
  type        = string
  description = "S3 path to avg device mapping config"
}

variable "device_mapping_path" {
  type        = string
  description = "S3 path to device mapping config"
}

variable "merchant_mapping_path" {
  type        = string
  description = "S3 path to merchant mapping config"
}

variable "sms_mapping_path" {
  type        = string
  description = "S3 path to sms mapping config"
}

variable "sms_mapping_v2_path" {
  type        = string
  description = "S3 path to sms mapping v2 config"
}

variable "company_model_path" {
  type        = string
  description = "S3 path to company model config"
}

variable "company_vectorizer_path" {
  type        = string
  description = "S3 path to company vectorizer config"
}

variable "count_vectorizer_path" {
  type        = string
  description = "S3 path to count vectorizer config"
}

variable "label_model_path" {
  type        = string
  description = "S3 path to label model config"
}

variable "lr_model_path" {
  type        = string
  description = "S3 path to lr model config"
}

variable "merchant_label_v2_path" {
  type        = string
  description = "S3 path to merchant label v2 config"
}

variable "merchant_label_path" {
  type        = string
  description = "S3 path to merchant label config"
}

variable "merchant_model_v2_path" {
  type        = string
  description = "S3 path to merchant model v2 config"
}

variable "merchant_model_path" {
  type        = string
  description = "S3 path to merchant model config"
}

variable "merchant_vectorizer_v2_path" {
  type        = string
  description = "S3 path to merchant vectorizer v2 config"
}

variable "merchant_vectorizer_path" {
  type        = string
  description = "S3 path to merchant vectorizer config"
}

variable "lgb_score_model_path" {
  type        = string
  description = "S3 path to lgb score model config"
}

variable "payday_score_lgb_model_path" {
  type        = string
  description = "S3 path to payday score lgb model config"
}

variable "payday_score_lgb_model_v2_path" {
  type        = string
  description = "S3 path to payday score lgb model v2 config"
}

variable "payday_score_lgb_model_v3_path" {
  type        = string
  description = "S3 path to payday score lgb model v3 config"
}

variable "predictors_score_lgb_model_path" {
  type        = string
  description = "S3 path to predictors score lgb model config"
}

variable "predictors_payday_score_lgb_model_path" {
  type        = string
  description = "S3 path to predictors payday score lgb model config"
}

variable "predictors_payday_score_lgb_model_v2_path" {
  type        = string
  description = "S3 path to predictors payday score lgb model v2 config"
}

variable "predictors_payday_score_lgb_model_v3_path" {
  type        = string
  description = "S3 path to predictors payday score lgb model v3 config"
}
