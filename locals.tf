locals {
  common_tags = {
    Stage    = var.environment
    Owner    = var.stack_owner
    Team     = var.stack_team
    Pipeline = var.application
    Org      = var.organization
  }

  ecr_registry     = format("%s.dkr.ecr.%s.amazonaws.com", data.aws_caller_identity.current.account_id, var.region)
  stack_identifier = format("%s-%s", var.application, var.environment)

  allowed_api_paths_1 = [
    "/api/fetch_data",
    "/api/insights",
    "/api/async_insights",
    "/api/operation_auth",
    "/api/configure_client"
  ]

  allowed_api_paths_2 = [
    "/api/generate_features",
    "/api/async_generate_features",
    "/api/ext_fetch_features",
    "/api/async_ext_fetch_features",
    "/api/fetch_extracted_data"
  ]
}