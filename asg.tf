resource "aws_autoscaling_group" "main" {
  name            = local.stack_identifier
  placement_group = aws_placement_group.main.id

  min_size         = var.asg_min_size
  desired_capacity = var.asg_desired_size
  max_size         = var.asg_max_size

  default_cooldown          = 60  # seconds
  health_check_grace_period = 120 # seconds
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.private_subnet_ids
  termination_policies      = ["OldestInstance"]
  metrics_granularity       = "1Minute"
  target_group_arns         = [aws_lb_target_group.main.arn]

  launch_template {
    id      = aws_launch_template.main.id
    version = aws_launch_template.main.latest_version
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      checkpoint_percentages = [50, 100]
      min_healthy_percentage = 50
      checkpoint_delay       = 120
    }
  }

  # propagate_at_launch is false as instance and volume tags are specified in Launch Template
  tag {
    key                 = "Name"
    value               = local.stack_identifier
    propagate_at_launch = false
  }

  tag {
    key                 = "ResourceType"
    value               = "server"
    propagate_at_launch = false
  }

  dynamic "tag" {
    for_each = local.common_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = false
    }
  }
}

resource "aws_autoscaling_schedule" "scheduled_scaling" {
  count = var.enable_scheduled_scaling ? length(var.scaling_schedules) : 0

  scheduled_action_name  = format("%s-scheduled-scaling-action-%s", local.stack_identifier, count.index)
  autoscaling_group_name = aws_autoscaling_group.main.name

  min_size         = var.scaling_schedules[count.index].min_size
  max_size         = var.scaling_schedules[count.index].max_size
  desired_capacity = var.scaling_schedules[count.index].desired_capacity
  time_zone        = "Asia/Kolkata"
  recurrence       = var.scaling_schedules[count.index].cron_expression
}

resource "aws_autoscaling_policy" "upscale" {
  name                   = format("%s-upscale-policy", local.stack_identifier)
  scaling_adjustment     = 2 # number of servers to add once triggered
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60 # seconds
  autoscaling_group_name = aws_autoscaling_group.main.name
}

resource "aws_autoscaling_policy" "downscale" {
  name                   = format("%s-downscale-policy", local.stack_identifier)
  scaling_adjustment     = -1 # number of servers to add once triggered
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300 # seconds
  autoscaling_group_name = aws_autoscaling_group.main.name
}
