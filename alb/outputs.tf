output "alb_id" {
  value = "${aws_lb.main_alb.id}"
}

output "alb_tg_arn" {
  value = "${aws_lb_target_group.main_tg.arn}"
}

output "alb_dns_name" {
  value = "${aws_lb.main_alb.dns_name}"
}

output "alb_zone_id" {
  value = "${aws_lb.main_alb.zone_id}"
}
