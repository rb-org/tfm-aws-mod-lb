// ALB Security Group

##########
## Ingress
##########

resource "aws_security_group_rule" "ir_https_sgs_tcp" {
  count                    = "${length(var.allowed_sgs) * local.create_alb}"
  type                     = "ingress"
  from_port                = "${var.https_listeners_port}"
  to_port                  = "${var.https_listeners_port}"
  protocol                 = "tcp"
  source_security_group_id = "${var.allowed_sgs[count.index]}"
  security_group_id        = "${data.aws_security_group.alb.id}"
  description              = "${var.instance_desc} ${upper(var.app_id)} ALB HTTPS Rule - Allowed SGs"
}

resource "aws_security_group_rule" "ir_https_cidr_tcp" {
  count             = "${(length(var.allowed_ips) * local.create_alb) > 0 ? 1 : 0}"
  type              = "ingress"
  from_port         = "${var.https_listeners_port}"
  to_port           = "${var.https_listeners_port}"
  protocol          = "tcp"
  cidr_blocks       = ["${var.allowed_ips}"]
  security_group_id = "${data.aws_security_group.alb.id}"
  description       = "${var.instance_desc} ${upper(var.app_id)} ALB HTTPS Rule - Allowed IPs"
}
