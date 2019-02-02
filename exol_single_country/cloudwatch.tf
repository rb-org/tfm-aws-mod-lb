#############
# ALB - Blue Host HealthCheck
#############
resource "aws_cloudwatch_metric_alarm" "lb_unhealthy_hosts_blue" {
  count = "${local.evaluate_target_health}"

  actions_enabled = "${local.enable_cloudwatch_alarm_actions}"

  alarm_actions = [
    "${local.sns_emergency_arn}",
  ]

  alarm_description   = "Unhealthy Host count is above threshold"
  alarm_name          = "${aws_lb.blue.name} - ${var.instance_desc} ${upper(var.app_id)} - ALB Unhealthy Host Count"
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = "${aws_lb.blue.arn_suffix}"
    TargetGroup  = "${aws_lb_target_group.blue.arn_suffix}"
  }

  evaluation_periods = "${var.lb_unhealthy_hosts_alarm_evaluation_periods}"
  metric_name        = "UnHealthyHostCount"
  namespace          = "AWS/ApplicationELB"

  ok_actions = [
    "${local.sns_ok_arn}",
  ]

  period    = "${var.lb_unhealthy_hosts_alarm_period}"
  statistic = "Average"
  threshold = "${var.lb_unhealthy_hosts_alarm_threshold}"
  unit      = "Count"
}

#############
# ALB - Green Host HealthCheck
#############
resource "aws_cloudwatch_metric_alarm" "lb_unhealthy_hosts_green" {
  count = "${local.evaluate_target_health}"

  actions_enabled = "${local.enable_cloudwatch_alarm_actions}"

  alarm_actions = [
    "${local.sns_emergency_arn}",
  ]

  alarm_description   = "Unhealthy Host count is above threshold"
  alarm_name          = "${aws_lb.green.name} - ${var.instance_desc} ${upper(var.app_id)} - ALB Unhealthy Host Count"
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = "${aws_lb.green.arn_suffix}"
    TargetGroup  = "${aws_lb_target_group.green.arn_suffix}"
  }

  evaluation_periods = "${var.lb_unhealthy_hosts_alarm_evaluation_periods}"
  metric_name        = "UnHealthyHostCount"
  namespace          = "AWS/ApplicationELB"

  ok_actions = [
    "${local.sns_ok_arn}",
  ]

  period    = "${var.lb_unhealthy_hosts_alarm_period}"
  statistic = "Average"
  threshold = "${var.lb_unhealthy_hosts_alarm_threshold}"
  unit      = "Count"
}
