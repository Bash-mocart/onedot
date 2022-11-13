# autoscaling group to provide 2 ec2 instances in 2 public subnets
resource "aws_autoscaling_group" "onedot_autoscaling" {
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  health_check_grace_period = 300
  health_check_type         = var.asg_health_check_type


  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"
  

  launch_template {
    id      = aws_launch_template.onedot_launch.id
    version = aws_launch_template.onedot_launch.latest_version
  }
    vpc_zone_identifier  = [ var.pri_subnet_a,
        var.pri_subnet_b
     ]
    # ignoring changes on load balancers and target group arns 
    lifecycle {
        ignore_changes = [load_balancers, target_group_arns]
    }



  tag {
        key                = "ResourceName"
        value              = "${var.project}-asg" 
        propagate_at_launch = true
  }
     tag {
        key                = "Owner"
        value              = "InfraTeam"
        propagate_at_launch = true
  }
   tag {
        key                = "environment"
        value              = "autoscaling-${var.environment}"
        propagate_at_launch = true
  }

}
# autoscaling attachment to alb
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.onedot_autoscaling.id
  lb_target_group_arn    = var.aws_lb_target_group_arn
}

# scale up policy
resource "aws_autoscaling_policy" "onedot_scale_up" {
  name                   = "${var.project}-auto-scale-up"
  autoscaling_group_name = aws_autoscaling_group.onedot_autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}


# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "onedot_scale_up_alarm" {
  alarm_name          = "${var.project}-scale-up-alarm"
  alarm_description   = "onedot-scaling-up-alarm-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80" # New instance will be created once CPU utilization is higher than 80 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.onedot_autoscaling.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.onedot_scale_up.arn]
}

# scale down policy
resource "aws_autoscaling_policy" "onedot_scale_down" {
  name                   = "${var.project}-scale-down"
  autoscaling_group_name = aws_autoscaling_group.onedot_autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "onedot_scale_down_alarm" {
  alarm_name          = "${var.project}-scale-down-alarm"
  alarm_description   = "onedot-scaling-down-alarm-cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5" # Instance will scale down when CPU utilization is lower than 5 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.onedot_autoscaling.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.onedot_scale_down.arn]
}











