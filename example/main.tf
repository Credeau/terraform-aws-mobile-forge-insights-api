data "aws_ssm_parameter" "mongo_user_name" {
  name            = "DUMMY_MONGO_USER"
  with_decryption = true
}

data "aws_ssm_parameter" "mongo_password" {
  name            = "DUMMY_MONGO_PASSWORD"
  with_decryption = true
}

data "aws_ssm_parameter" "postgres_user_name" {
  name            = "DUMMY_POSTGRES_USER"
  with_decryption = true
}

data "aws_ssm_parameter" "postgres_password" {
  name            = "DUMMY_POSTGRES_PASSWORD"
  with_decryption = true
}

module "device_insights" {
  source = "git::https://github.com/credeau/terraform-aws-mobile-forge-insights-api.git?ref=v1.0.0"

  application             = "di-insights"
  environment             = "prod"
  region                  = "ap-south-1"
  certificate_domain_name = "*.credeau.com"
  stack_owner             = "tech@credeau.com"
  stack_team              = "devops"
  organization            = "credeau"
  alert_email_recipients  = []

  instance_type                  = "c6a.xlarge"
  ecr_repository                 = "mobile-forge-insights"
  ecr_image_tag                  = "1.7.3"
  root_volume_size               = 25
  ami_id                         = "ami-00000000000000000"
  key_name                       = "mobile-forge-demo"
  asg_min_size                   = 1
  asg_max_size                   = 1
  asg_desired_size               = 1
  upscale_evaluation_period      = 60
  downscale_evaluation_period    = 300
  logs_retention_period          = 7
  api_timeout                    = 60
  scaling_cpu_threshold          = 60
  scaling_memory_threshold       = 60
  scaling_disk_threshold         = 60
  mapped_port                    = 8000
  application_port               = 8000
  enable_scheduled_scaling       = false
  timezone                       = "Asia/Kolkata"
  upscale_schedule               = "cron(0 10 * * ? *)"
  scheduled_upscale_min_size     = 1
  scheduled_upscale_max_size     = 1
  scheduled_upscale_desired_size = 1
  downscale_schedule             = "cron(0 10 * * ? *)"
  enable_alb_access_logs         = false

  vpc_id                   = "vpc-00000000000000000"
  private_subnet_ids       = ["subnet-00000000000000000"]
  public_subnet_ids        = ["subnet-00000000000000000"]
  internal_security_groups = ["sg-00000000000000000"]
  external_security_groups = ["sg-00000000000000000"]
  waf_rate_limit           = 100
  allowed_ips              = ["0.0.0.0/0"]
  use_public_endpoint      = true

  postgres_user_name = data.aws_ssm_parameter.postgres_user_name.value
  postgres_password  = data.aws_ssm_parameter.postgres_password.value
  postgres_host      = aws_db_instance.postgres.address
  postgres_port      = 5432
  postgres_db        = "api_insights_db"
  postgres_sync_db   = "sync_db"
  mongo_username     = data.aws_ssm_parameter.mongo_user_name.value
  mongo_password     = data.aws_ssm_parameter.mongo_password.value
  mongo_host         = module.mongo.host_address
  mongo_port         = 27017
  mongo_db           = "sync_db"

  sms_extractor_host       = module.sms_extractor.host_address
  sms_extractor_batch_size = "1000"

  apps_mapping_path                         = "s3://bucket_name/configs/india_configs_apps_mapping.json.enc"
  avg_device_mapping_path                   = "s3://bucket_name/configs/india_configs_avg_device_price.json.enc"
  device_mapping_path                       = "s3://bucket_name/configs/india_configs_device_pricing.json.enc"
  merchant_mapping_path                     = "s3://bucket_name/configs/india_configs_merchant_clean_sender_name_mapping.csv.enc"
  sms_mapping_path                          = "s3://bucket_name/configs/india_configs_sms_sender_mapping.json.enc"
  company_model_path                        = "s3://bucket_name/models/india_models_company_model.pkl.enc"
  company_vectorizer_path                   = "s3://bucket_name/models/india_models_company_vectorizer.pkl.enc"
  count_vectorizer_path                     = "s3://bucket_name/models/india_models_countvectorizer.pickle.enc"
  label_model_path                          = "s3://bucket_name/models/india_models_label_encoder.pickle.enc"
  lr_model_path                             = "s3://bucket_name/models/india_models_lr.pickle.enc"
  merchant_label_v2_path                    = "s3://bucket_name/models/india_models_merchant_label_encoder_v2.pkl.enc"
  merchant_label_path                       = "s3://bucket_name/models/india_models_merchant_label_encoder.pkl.enc"
  merchant_model_v2_path                    = "s3://bucket_name/models/india_models_merchant_model_v2.pkl.enc"
  merchant_model_path                       = "s3://bucket_name/models/india_models_merchant_model.pkl.enc"
  merchant_vectorizer_v2_path               = "s3://bucket_name/models/india_models_merchant_vectorizer_v2.pkl.enc"
  merchant_vectorizer_path                  = "s3://bucket_name/models/india_models_merchant_vectorizer.pkl.enc"
  lgb_score_model_path                      = "s3://bucket_name/scoring/india_scoring_lgb_model.pkl.enc"
  payday_score_lgb_model_path               = "s3://bucket_name/scoring/india_scoring_payday_lgb_model.pkl.enc"
  payday_score_lgb_model_v2_path            = "s3://bucket_name/scoring/india_scoring_payday_lgb_model_20250623.pkl.enc"
  payday_score_lgb_model_v3_path            = "s3://bucket_name/scoring/india_scoring_payday_lgb_model_20250703.pkl.enc"
  predictors_score_lgb_model_path           = "s3://bucket_name/scoring/india_scoring_predictors_lgb.pkl.enc"
  predictors_payday_score_lgb_model_path    = "s3://bucket_name/scoring/india_scoring_predictors_payday_lgb_model.pkl.enc"
  predictors_payday_score_lgb_model_v2_path = "s3://bucket_name/scoring/india_scoring_predictors_payday_lgb_model_20250623.pkl.enc"
  predictors_payday_score_lgb_model_v3_path = "s3://bucket_name/scoring/india_scoring_predictors_payday_lgb_model_20250703.pkl.enc"
}

output "device_insights" {
  value = module.device_insights
}
