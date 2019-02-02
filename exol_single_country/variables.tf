##############
# General
##############

variable "vpc_id" {
  default     = ""
  description = "Required"
}

variable "country" {
  description = "Country Code"
  default     = ""
}

# variable "countries" {
#   description = "Country Code"
#   type        = "list"
#   default     = ["be"]
# }

variable "subnets" {
  type        = "list"
  default     = [""]
  description = "Required: for external facing LBs this is a list of public subnets"
}

variable "domain_name" {}

variable "tags" {
  type    = "map"
  default = {}
}

variable "instance_desc" {
  description = "Long name of instance type"
}

variable "instance_count" {
  default = 0
}

##############
# Security Groups
##############

variable "allowed_ips" {
  type = "list"
}

variable "allowed_sgs" {
  type = "list"
}

variable "security_group_name_alb" {}

##############
# LB
##############

variable "create_alb" {
  default = false
}

variable "lb_name_blue_suffix" {
  default = "main"
}

variable "lb_name_green_suffix" {
  default = "fail"
}

variable "app_id" {}

variable "enable_deletion_protection" {
  default = false
}

variable "enable_http2" {
  default = true
}

variable "ssl_cert_arn" {
  description = "Required: "
}

variable "https_listeners_port" {
  default = 443
}

# LB Defaults

variable "idle_timeout" {
  default = 600
}

variable "ip_address_type" {
  default = "ipv4"
}

variable "listener_ssl_policy_default" {
  default = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "load_balancer_create_timeout" {
  default = "10m"
}

variable "load_balancer_delete_timeout" {
  default = "10m"
}

variable "load_balancer_is_internal" {
  default = false
}

variable "load_balancer_update_timeout" {
  default = "10m"
}

variable "log_bucket_name" {
  default = "lb-log-bucket"
}

variable "log_location_prefix" {
  default = ""
}

# variable "logging_enabled" {
#   default = false
# }

variable "backend_port_blue" {
  default = 81
}

variable "backend_port_green" {
  default = 91
}

variable "backend_port_main" {
  default = 81
}

variable "backend_port_fail" {
  default = 91
}

variable "backend_protocol" {
  default = "HTTP"
}

variable "enable_cross_zone_load_balancing" {
  description = "Indicates whether cross zone load balancing should be enabled in application load balancers."
  default     = false
}

# TG Defaults

variable "cookie_duration" {
  default = 7200
}

variable "deregistration_delay" {
  default = 300
}

variable "health_check_healthy_threshold" {
  default = 3
}

variable "health_check_interval" {
  default = 10
}

variable "health_check_matcher" {
  default = "200-302"
}

variable "health_check_path" {
  default = "/docs/sysstatus.aspx"
}

variable "health_check_port" {
  default = "traffic-port"
}

variable "health_check_protocol" {
  default = "HTTP"
}

variable "health_check_timeout" {
  default = 5
}

variable "health_check_unhealthy_threshold" {
  default = 5
}

variable "stickiness_enabled" {
  default = true
}

variable "target_type" {
  default = "instance"
}

variable "target_instance_ids" {
  type = "list"
}

##############
# Cloudwatch
##############
variable "enable_route53_health_checks" {
  type    = "map"
  default = {}
}

variable "route53_health_check_regions" {
  type    = "list"
  default = ["sa-east-1", "us-west-1", "us-west-2", "ap-northeast-1", "ap-southeast-1", "eu-west-1", "us-east-1", "ap-southeast-2"]
}

variable "route53_health_check_path" {}
variable "route53_health_check_stringmatch" {}

variable "evaluate_target_health" {
  type    = "map"
  default = {}
}

variable "enable_cloudwatch_alarm_actions" {
  type    = "map"
  default = {}
}

variable "lb_unhealthy_hosts_alarm_evaluation_periods" {
  default = "10"
}

variable "lb_unhealthy_hosts_alarm_period" {
  default = "60"
}

variable "lb_unhealthy_hosts_alarm_threshold" {
  default = "1"
}

variable "r53_healhcheck_type" {
  default     = "HTTPS"
  description = "Can be HTTP, HTTPS, TCP. Use HTTP_STR_MATCH or HTTPS_STR_MATCH when combined with search_string"
}

variable "r53_healhcheck_port" {
  default = 443
}

variable "r53_healhcheck_resource_path" {
  default = ""
}

variable "r53_healhcheck_request_interval" {
  default = 30
}

variable "r53_healhcheck_failure_threshold" {
  default = 5
}
