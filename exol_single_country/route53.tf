resource "aws_route53_record" "blue" {
  count   = "${local.create_alb * local.enable_r53_hcs}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "${local.lb_name_failover}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.blue.dns_name}"
    zone_id                = "${aws_lb.blue.zone_id}"
    evaluate_target_health = "${local.evaluate_target_health}"
  }

  set_identifier  = "${local.lb_name_failover}-primary"
  health_check_id = "${aws_route53_health_check.lb_r53_healthcheck_blue.id}"

  failover_routing_policy {
    type = "PRIMARY"
  }
}

resource "aws_route53_record" "green" {
  count   = "${local.create_alb * local.enable_r53_hcs}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  name    = "${local.lb_name_failover}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_lb.green.dns_name}"
    zone_id                = "${aws_lb.green.zone_id}"
    evaluate_target_health = "${local.evaluate_target_health}"
  }

  set_identifier = "${local.lb_name_failover}-secondary"

  failover_routing_policy {
    type = "SECONDARY"
  }
}

provider "aws" {
  alias  = "cloudwatch"
  region = "us-east-1"
}

#############
# ALB - R53 HC - Only 1 required
#############

resource "aws_route53_health_check" "lb_r53_healthcheck_blue" {
  count             = "${local.enable_r53_hcs}"
  fqdn              = "${aws_lb.blue.dns_name}"
  type              = "${local.r53_healhcheck_type}"            # can be HTTP, HTTPS, TCP. Use HTTP_STR_MATCH or HTTPS_STR_MATCH when combined with search_string
  port              = "${var.r53_healhcheck_port}"
  resource_path     = "${var.route53_health_check_path}"
  failure_threshold = "${var.r53_healhcheck_failure_threshold}"
  request_interval  = "${var.r53_healhcheck_request_interval}"
  regions           = "${var.route53_health_check_regions}"

  search_string = "${var.route53_health_check_stringmatch}"

  tags {
    Name = "${local.lb_name_blue}-${var.https_listeners_port}-healthcheck"
  }
}

resource "aws_cloudwatch_metric_alarm" "lb_r53_healthcheck_alarm_blue" {
  count = "${local.enable_r53_hcs}"

  provider = "aws.cloudwatch"

  actions_enabled = "${local.enable_cloudwatch_alarm_actions}"

  alarm_actions = [
    "${local.sns_emergency_arn_cw}",
  ]

  alarm_name          = "${element(aws_route53_health_check.lb_r53_healthcheck_blue.*.tags.Name, count.index)}"
  alarm_description   = "R53 healthcheck has become unhealthy for ${aws_lb.blue.dns_name}"
  statistic           = "Minimum"
  comparison_operator = "LessThanThreshold"
  threshold           = "1"
  evaluation_periods  = "10"
  period              = "60"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"

  dimensions = {
    HealthCheckId = "${element(aws_route53_health_check.lb_r53_healthcheck_blue.*.id, count.index)}"
  }

  ok_actions = [
    "${local.sns_ok_arn_cw}",
  ]
}
