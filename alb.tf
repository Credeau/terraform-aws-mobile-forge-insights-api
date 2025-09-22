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
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.main.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
