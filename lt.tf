resource "aws_launch_template" "main" {
  name          = format("%s-lt", local.stack_identifier)
  instance_type = var.instance_type


  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = var.root_volume_size
      volume_type = "gp3"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  # Note:
  # use this block only if public ip is required on instances
  # remember to use public subnets in var.subnet_ids
  # ---------------------------------------------------------
  network_interfaces {
    # associate_public_ip_address = true
    security_groups = var.internal_security_groups
  }

  # comment out if above is being used
  # vpc_security_group_ids = var.internal_security_groups

  ebs_optimized = true

  iam_instance_profile {
    arn = aws_iam_instance_profile.main.arn
  }

  image_id = var.ami_id

  key_name = var.key_name

  monitoring {
    enabled = true
  }

  user_data = base64encode(templatefile(
    "${path.module}/files/userdata.sh.tftpl",
    {
      region                                    = var.region
      registry                                  = local.ecr_registry
      environment                               = var.environment
      ecr_repository                            = var.ecr_repository
      image_tag                                 = var.ecr_image_tag
      application                               = var.application
      mapped_port                               = var.mapped_port
      application_port                          = var.application_port
      postgres_user_name                        = var.postgres_user_name
      postgres_password                         = var.postgres_password
      postgres_host                             = var.postgres_host
      postgres_port                             = var.postgres_port
      postgres_db                               = var.postgres_db
      postgres_sync_db                          = var.postgres_sync_db
      mongo_username                            = var.mongo_username
      mongo_password                            = var.mongo_password
      mongo_host                                = var.mongo_host
      mongo_port                                = var.mongo_port
      mongo_db                                  = var.mongo_db
      mongo_enabled_sources                     = var.mongo_enabled_sources
      mongo_max_pool_size                       = var.mongo_max_pool_size
      mongo_min_pool_size                       = var.mongo_min_pool_size
      mongo_server_selection_timeout_ms         = var.mongo_server_selection_timeout_ms
      mongo_connect_timeout_ms                  = var.mongo_connect_timeout_ms
      mongo_socket_timeout_ms                   = var.mongo_socket_timeout_ms
      mongo_retry_writes                        = var.mongo_retry_writes
      mongo_wait_queue_timeout_ms               = var.mongo_wait_queue_timeout_ms
      sms_extractor_host                        = var.sms_extractor_host
      sms_extractor_batch_size                  = var.sms_extractor_batch_size
      log_group                                 = aws_cloudwatch_log_group.main.name
      apps_mapping_path                         = var.apps_mapping_path
      fraud_apps_mapping_path                   = var.fraud_apps_mapping_path
      avg_device_mapping_path                   = var.avg_device_mapping_path
      device_mapping_path                       = var.device_mapping_path
      merchant_mapping_path                     = var.merchant_mapping_path
      sms_mapping_path                          = var.sms_mapping_path
      sms_mapping_v2_path                       = var.sms_mapping_v2_path
      company_model_path                        = var.company_model_path
      company_vectorizer_path                   = var.company_vectorizer_path
      count_vectorizer_path                     = var.count_vectorizer_path
      label_model_path                          = var.label_model_path
      lr_model_path                             = var.lr_model_path
      merchant_label_v2_path                    = var.merchant_label_v2_path
      merchant_label_path                       = var.merchant_label_path
      merchant_model_v2_path                    = var.merchant_model_v2_path
      merchant_model_path                       = var.merchant_model_path
      merchant_vectorizer_v2_path               = var.merchant_vectorizer_v2_path
      merchant_vectorizer_path                  = var.merchant_vectorizer_path
      lgb_score_model_path                      = var.lgb_score_model_path
      payday_score_lgb_model_path               = var.payday_score_lgb_model_path
      payday_score_lgb_model_v2_path            = var.payday_score_lgb_model_v2_path
      payday_score_lgb_model_v3_path            = var.payday_score_lgb_model_v3_path
      predictors_score_lgb_model_path           = var.predictors_score_lgb_model_path
      predictors_payday_score_lgb_model_path    = var.predictors_payday_score_lgb_model_path
      predictors_payday_score_lgb_model_v2_path = var.predictors_payday_score_lgb_model_v2_path
      predictors_payday_score_lgb_model_v3_path = var.predictors_payday_score_lgb_model_v3_path
      emi_score_lgb_model_v2_path               = var.emi_score_lgb_model_v2_path
      predictors_emi_score_lgb_model_v2_path    = var.predictors_emi_score_lgb_model_v2_path
    }
  ))

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-lt", local.stack_identifier)
    }
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      local.common_tags,
      {
        Name : local.stack_identifier,
        ResourceType : "server"
      }
    )
  }

  tag_specifications {
    resource_type = "network-interface"

    tags = merge(
      local.common_tags,
      {
        Name : local.stack_identifier,
        ResourceType : "network"
      }
    )
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
      local.common_tags,
      {
        Name : local.stack_identifier,
        ResourceType : "storage"
      }
    )
  }
}
