resource "aws_lb" "main" {
  name               = format("%s-alb", local.stack_identifier)
  internal           = !var.use_public_endpoint
  idle_timeout       = var.api_timeout
  load_balancer_type = "application"
  security_groups    = var.use_public_endpoint ? var.external_security_groups : var.internal_security_groups
  subnets            = var.use_public_endpoint ? var.public_subnet_ids : var.private_subnet_ids

  access_logs {
    bucket  = aws_s3_bucket.access_logs.id
    enabled = var.enable_alb_access_logs
  }

  tags = merge(
    local.common_tags,
    {
      Name : format("%s-alb", local.stack_identifier),
      ResourceType : "load-balancer",
    }
  )
}

resource "aws_lb_listener" "http" {
  count = !var.use_public_endpoint ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "403 Forbidden"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "http_rule_1" {
  count = !var.use_public_endpoint ? 1 : 0

  listener_arn = aws_lb_listener.http[0].arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = local.allowed_api_paths_1
    }
  }
}

resource "aws_lb_listener_rule" "http_rule_2" {
  count = !var.use_public_endpoint ? 1 : 0

  listener_arn = aws_lb_listener.http[0].arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = local.allowed_api_paths_2
    }
  }
}

resource "aws_lb_listener" "https" {
  count = var.use_public_endpoint ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.main.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "403 Forbidden"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "https_rule_1" {
  count = var.use_public_endpoint ? 1 : 0

  listener_arn = aws_lb_listener.https[0].arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = local.allowed_api_paths_1
    }
  }
}

resource "aws_lb_listener_rule" "https_rule_2" {
  count = var.use_public_endpoint ? 1 : 0

  listener_arn = aws_lb_listener.https[0].arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = local.allowed_api_paths_2
    }
  }
}