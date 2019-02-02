data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "zone" {
  name         = "${var.domain_name}."
  private_zone = false
}

data "aws_security_group" "alb" {
  count = "${local.create_alb}"

  filter {
    name   = "group-name"
    values = ["${var.security_group_name_alb}"]
  }

  tags {
    Country = "${var.country}"
    AppID   = "${var.app_id}"
  }
}
