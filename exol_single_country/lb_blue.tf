resource "aws_lb" "blue" {
  count                      = "${local.create_alb}"
  load_balancer_type         = "application"
  name                       = "${local.lb_name_blue}"
  internal                   = false
  security_groups            = ["${data.aws_security_group.alb.id}"]
  subnets                    = ["${var.subnets}"]
  idle_timeout               = "${var.idle_timeout}"
  enable_deletion_protection = "${var.enable_deletion_protection}"
  enable_http2               = "${var.enable_http2}"
  ip_address_type            = "${var.ip_address_type}"

  tags = "${merge(var.tags, map(
      "Name", local.lb_name_blue,
      "AppID", var.app_id,
      "Country", var.country
      ))}"

  access_logs {
    enabled = true
    bucket  = "${var.log_bucket_name}"
    prefix  = "${local.log_location_prefix_blue}"
  }

  timeouts {
    create = "${var.load_balancer_create_timeout}"
    delete = "${var.load_balancer_delete_timeout}"
    update = "${var.load_balancer_update_timeout}"
  }
}

resource "aws_lb_target_group" "blue" {
  count                = "${local.create_alb}"
  name                 = "${local.tg_name_blue}"
  vpc_id               = "${var.vpc_id}"
  port                 = "${local.backend_port_blue}"
  protocol             = "${var.backend_protocol}"
  deregistration_delay = "${var.deregistration_delay}"
  target_type          = "${var.target_type}"

  health_check {
    interval            = "${var.health_check_interval}"
    path                = "${var.health_check_path}"
    port                = "${var.health_check_port}"
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    timeout             = "${var.health_check_timeout}"
    protocol            = "${var.health_check_protocol}"
    matcher             = "${var.health_check_matcher}"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = "${var.cookie_duration}"
    enabled         = "${var.stickiness_enabled}"
  }

  tags = "${
    merge(var.tags, map(
      "Name", local.tg_name_blue,
      "AppID", var.app_id,
      "Country", var.country
      ))}"

  depends_on = ["aws_lb.blue"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "blue" {
  count             = "${local.create_alb}"
  load_balancer_arn = "${aws_lb.blue.arn}"
  port              = "${var.https_listeners_port}"
  protocol          = "HTTPS"
  certificate_arn   = "${var.ssl_cert_arn}"
  ssl_policy        = "${var.listener_ssl_policy_default}"

  default_action {
    target_group_arn = "${aws_lb_target_group.blue.id}"
    type             = "forward"
  }
}

resource "aws_lb_target_group_attachment" "blue" {
  count            = "${local.tg_attachment}"
  target_group_arn = "${aws_lb_target_group.blue.arn}"
  target_id        = "${var.target_instance_ids[count.index]}"
  port             = "${var.backend_port_blue}"
}
