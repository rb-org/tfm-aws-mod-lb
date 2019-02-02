resource "aws_route53_record" "production" {
  zone_id = "${var.dns_zone}"
  name    = "${var.name}-production"
  type    = "A"

  alias {
    name                   = "${var.prod_lb_dns_name}"
    zone_id                = "${var.prod_lb_dns_zone}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "fallback" {
  zone_id = "${var.dns_zone}"
  name    = "${var.name}-fallback"
  type    = "A"

  alias {
    name                   = "${var.fallback_lb_dns_name}"
    zone_id                = "${var.fallback_lb_dns_zone}"
    evaluate_target_health = false
  }
}

resource "aws_route53_health_check" "healthcheck" {
  fqdn              = "${aws_route53_record.production.fqdn}"
  type              = "${var.r53_healthcheck_type}"
  port              = "${var.r53_healthcheck_port}"
  resource_path     = "${var.r53_healthcheck_path}"
  failure_threshold = "${var.r53_healthcheck_failure_threshold}"
  request_interval  = "${var.r53_healthcheck_request_interval}"
  search_string     = "${var.r53_healthcheck_stringmatch}"

  tags {
    Name = "${var.name}-alb-healthcheck"
  }
}

resource "aws_route53_record" "failover_production" {
  zone_id         = "${var.dns_zone}"
  name            = "${var.name}"
  type            = "CNAME"
  ttl             = "30"
  records         = ["${aws_route53_record.production.fqdn}"]
  health_check_id = "${aws_route53_health_check.healthcheck.id}"
  set_identifier  = "${var.name}_production"

  failover_routing_policy {
    type = "PRIMARY"
  }
}

resource "aws_route53_record" "failover_fallback" {
  zone_id        = "${var.dns_zone}"
  name           = "${var.name}"
  type           = "CNAME"
  ttl            = "30"
  records        = ["${aws_route53_record.fallback.fqdn}"]
  set_identifier = "${var.name}_fallback"

  failover_routing_policy {
    type = "SECONDARY"
  }
}
