locals {
  create_alb       = "${var.create_alb ? 1 :0}"
  tg_attachment    = "${var.create_alb && (var.instance_count > 0) ? var.instance_count : 0}"
  lb_name_failover = "${var.country == "" ? "${local.name_prefix}-${var.app_id}-alb" : "${local.name_prefix}-${var.app_id}-${var.country}-alb"}"

  #### Blue
  lb_name_blue_suffix = "${var.lb_name_blue_suffix}"
  lb_name_blue        = "${local.lb_name_failover}-${local.lb_name_blue_suffix}"
  tg_name_blue        = "${local.lb_name_failover}-${local.lb_name_blue_suffix}-tg"

  backend_port_blue        = "${var.backend_port_main}"
  log_location_prefix_blue = "${var.log_location_prefix == "" ? local.lb_name_blue : var.log_location_prefix}"

  #### Green
  lb_name_green_suffix      = "${var.lb_name_green_suffix}"
  lb_name_green             = "${local.lb_name_failover}-${local.lb_name_green_suffix}"
  tg_name_green             = "${local.lb_name_failover}-${local.lb_name_green_suffix}-tg"
  backend_port_green        = "${var.backend_port_fail}"
  log_location_prefix_green = "${var.log_location_prefix == "" ? local.lb_name_green : var.log_location_prefix}"

  #### Main
  name_prefix                     = "${terraform.workspace}"
  account_id                      = "${data.aws_caller_identity.current.account_id}"
  local_region                    = "${data.aws_region.current.name}"
  r53_healhcheck_type             = "${var.route53_health_check_stringmatch != "" ? "HTTPS_STR_MATCH" : "HTTPS" }"
  enable_r53_hcs                  = "${(local.create_alb == 1 && var.enable_route53_health_checks[terraform.workspace]  || var.enable_route53_health_checks[terraform.workspace] =="true") ? 1 : 0}"
  evaluate_target_health          = "${(local.create_alb == 1 && var.evaluate_target_health[terraform.workspace]  || var.evaluate_target_health[terraform.workspace] =="true") ? 1 : 0}"
  enable_cloudwatch_alarm_actions = "${(var.enable_cloudwatch_alarm_actions[terraform.workspace]  || var.enable_cloudwatch_alarm_actions[terraform.workspace] =="true") ? true : false}"
  sns_topic_arn_prefix            = "arn:aws:sns:${local.local_region}:${local.account_id}:${local.name_prefix}"
  sns_topic_arn_prefix_cw         = "arn:aws:sns:us-east-1:${local.account_id}:${local.name_prefix}"
  sns_ok_arn                      = "${local.sns_topic_arn_prefix}-ok"
  sns_default_arn                 = "${local.sns_topic_arn_prefix}-default"
  sns_urgent_arn                  = "${local.sns_topic_arn_prefix}-urgent"
  sns_emergency_arn               = "${local.sns_topic_arn_prefix}-emergency"
  sns_ok_arn_cw                   = "${local.sns_topic_arn_prefix_cw}-ok"
  sns_default_arn_cw              = "${local.sns_topic_arn_prefix_cw}-default"
  sns_urgent_arn_cw               = "${local.sns_topic_arn_prefix_cw}-urgent"
  sns_emergency_arn_cw            = "${local.sns_topic_arn_prefix_cw}-emergency"
}
