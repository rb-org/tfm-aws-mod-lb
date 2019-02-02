resource "aws_lb" "main_alb" {
  name            = "${var.alb_name}"
  internal        = "${var.alb_internal}"
  security_groups = ["${var.alb_sg_list}"]
  subnets         = ["${var.alb_subnet_list}"]

  enable_deletion_protection = "${var.enable_del_protect}"

  idle_timeout    = "${var.alb_idle_timeout}"
  enable_http2    = "${var.alb_http2}"
  ip_address_type = "${var.alb_ip_address_type}"

  access_logs {
    enabled = "${var.alb_enable_access_logs}"
    bucket  = "${var.alb_access_logs_bucket}"
    prefix  = "${var.alb_access_logs_prefix == "" ? var.alb_name : var.alb_access_logs_prefix}"
  }

  tags = "${merge(var.default_tags,
    map("Name",                   "${var.alb_name}-${format("%02d", count.index+01)}"),
    map("AppID",                  "${var.app_id}"),
    map("AppRole",                "${var.app_role}"),
    map("Environment",            "${terraform.workspace}"),
    map("Version",                ""),
    map("AutomationUsed",         "TFM"),
    map("IsPII",                  ""),
    map("Owner",                  ""),
    map("CreatedBy",              "Exact"),
    map("BusinessUnit",           ""),
    map("CostCentre",             ""),
    map("Budget",                 ""),
    map("Project",                ""),
    map("Team",                   ""),
    map("Workload   ",            "${var.workload}"),
    map("CountryCode",            "${var.countrycode}")
    )
  }"
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.main_alb.arn}"
  port              = "${var.alb_listener_port}"
  protocol          = "${var.alb_listener_protocol}"
  ssl_policy        = "${var.alb_ssl_policy}"
  certificate_arn   = "${var.alb_certificate_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.main_tg.arn}"
    type             = "forward"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "main_tg" {
  name     = "${var.tg_name == "" ? local.tg_name : var.tg_name}"
  port     = "${var.tg_port}"
  protocol = "${var.tg_protocol}"
  vpc_id   = "${var.vpc_id}"

  stickiness {
    type            = "lb_cookie"
    cookie_duration = "${var.cookie_duration}"
    enabled         = "${var.sticky_enabled}"
  }

  health_check {
    interval            = "${var.hc_interval}"
    path                = "${var.hc_path}"
    port                = "${var.hc_port}"
    protocol            = "${var.hc_protocol}"
    timeout             = "${var.hc_timeout}"
    healthy_threshold   = "${var.hc_healthy}"
    unhealthy_threshold = "${var.hc_unhealthy}"
    matcher             = "${var.hc_matcher}"
  }

  tags = "${merge(var.default_tags,
    map("Name",                   "${var.tg_name == "" ? local.tg_name : var.tg_name}-${format("%02d", count.index+01)}"),
    map("AppID",                  "${var.app_id}"),
    map("AppRole",                "${var.app_role}"),
    map("Environment",            "${terraform.workspace}"),
    map("Version",                ""),
    map("AutomationUsed",         "TFM"),
    map("IsPII",                  ""),
    map("Owner",                  ""),
    map("CreatedBy",              "Exact"),
    map("BusinessUnit",           ""),
    map("CostCentre",             ""),
    map("Budget",                 ""),
    map("Project",                ""),
    map("Team",                   ""),
    map("Workload   ",            "${var.workload}"),
    map("CountryCode",            "${var.countrycode}")
    )
  }"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "main_tg_attachment" {
  count = "${length(var.instance_id)}"

  target_group_arn = "${aws_lb_target_group.main_tg.arn}"

  target_id = "${element(var.instance_id, count.index)}"
  port      = "${var.instance_port == "" ? var.tg_port : var.instance_port}"
}
