# Generic

variable "vpc_id" {
  default = ""
}

variable "app_id" {}
variable "app_role" {}
variable "countrycode" {}
variable "workload" {}

variable "default_tags" {
  type = "map"
}

# Load Balancer

variable "alb_name" {
  description = "The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen."
  default     = ""
}

variable "alb_internal" {
  description = "If true, the LB will be internal."
  default     = false
}

variable "alb_sg_list" {
  description = "A list of security group IDs to assign to the LB. "
  default     = [""]
}

variable "alb_subnet_list" {
  description = "A list of subnet IDs to attach to the LB. "
  default     = [""]
}

variable "alb_idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle. Default: 60."
  default     = "60"
}

variable "alb_http2" {
  description = "Indicates whether HTTP/2 is enabled in application load balancers. Defaults to true."
  default     = "true"
}

variable "alb_ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack"
  default     = "ipv4"
}

variable "enable_del_protect" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer."
  default     = true
}

# Load Balancer Access Logs

variable "alb_access_logs_bucket" {
  description = "The S3 bucket name to store the logs in."
  default     = ""
}

variable "alb_enable_access_logs" {
  description = "Boolean to enable / disable access_logs. Defaults to false, even when bucket is specified."
  default     = false
}

variable "alb_access_logs_prefix" {
  description = "The S3 bucket prefix. Logs are stored in the root if not configured. Defaults to alb_name."
  default     = ""
}

# Listener

variable "alb_listener_port" {
  description = "The port on which the load balancer is listening."
  default     = "443"
}

variable "alb_listener_protocol" {
  description = "The protocol for connections from clients to the load balancer. Valid values are TCP, HTTP and HTTPS."
  default     = "HTTPS"
}

variable "alb_ssl_policy" {
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS. Defaults to ELBSecurityPolicy-TLS-1-2-2017-01"
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "alb_certificate_arn" {
  description = "The ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS."
  default     = ""
}

/*
variable "alb_listener_rule_priority" {
  default = 100
}

variable "alb_listener_action" {
  default = "forward"
}

variable "alb_listener_condition_field" {
  default = "path-pattern"
} # "host-header"

variable "alb_listener_condition_value" {
  default = ["/static/*"]
} # ["my-service.*.terraform.io"]
*/

# Target Group

variable "tg_name" {
  description = "The name of the target group. Defaults to alb_name-tg"
  default     = ""
}

variable "tg_port" {
  description = "The port on which targets receive traffic, unless overridden when registering a specific target."
  default     = ""
}

variable "tg_protocol" {
  description = "The protocol to use for routing traffic to the targets. Should be one of TCP, HTTP, HTTPS or TLS."
  default     = ""
}

# Target Group Stickiness

variable "cookie_duration" {
  description = "The time period, in seconds, during which requests from a client should be routed to the same target. Default is 86400."
  default     = 86400
}

variable "sticky_enabled" {
  description = "Boolean to enable / disable stickiness. Default is true."
  default     = true
}

# Target Group Health Checks

variable "hc_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds. Default 30 seconds."
  default     = 300
}

variable "hc_path" {
  description = "The destination for the health check request."
  default     = ""
}

variable "hc_port" {
  description = "The port to use to connect with the target. Valid values are either ports 1-65536, or traffic-port. Defaults to traffic-port."
  default     = "traffic-port"
}

variable "hc_protocol" {
  description = "he protocol to use to connect with the target. Defaults to HTTP."
  default     = "HTTP"
}

variable "hc_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check. The range is 2 to 60 seconds and the default is 15 seconds."
  default     = 15
}

variable "hc_healthy" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy. Defaults to 5."
  default     = 5
}

variable "hc_unhealthy" {
  description = "The number of consecutive health check failures required before considering the target unhealthy. Defaults to 2."
  default     = 2
}

variable "hc_matcher" {
  description = "The HTTP codes to use when checking for a successful response from a target. You can specify multiple values (for example, 200,302) or a range of values (for example, 200-302). Defaults to 200-302"
  default     = "200-302"
}

# Target Group Attachments

variable "instance_id" {
  description = "A list of Instance IDs of the targets."
  type        = "list"
}

variable "instance_port" {
  description = "The port on which targets receive traffic. Defaults to tg_port value."
  default     = ""
}
