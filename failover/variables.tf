# Route 53

variable "name" {
  description = "The name of the record. Example: exol-nl-iw"
  default     = ""
}

variable "dns_zone" {
  description = "The ID of the hosted zone to contain this record."
  default     = ""
}

# Route 53 Health Check

variable "r53_healthcheck_type" {
  description = "The protocol to use when performing health checks. Valid values are HTTP, HTTPS, HTTP_STR_MATCH, HTTPS_STR_MATCH, TCP, CALCULATED and CLOUDWATCH_METRIC. Defaults to HTTPS_STR_MATCH."
  default     = "HTTPS_STR_MATCH"
}

variable "r53_healthcheck_port" {
  description = "The port of the endpoint to be checked. Defaults to 443."
  default     = "443"
}

variable "r53_healthcheck_path" {
  description = "The path that you want Amazon Route 53 to request when performing health checks. Defaults to /docs/sysstatus.aspx."
  default     = "/docs/sysstatus.aspx"
}

variable "r53_healthcheck_failure_threshold" {
  description = "The number of consecutive health checks that an endpoint must pass or fail. Defaults to 5."
  default     = "5"
}

variable "r53_healthcheck_request_interval" {
  description = "The number of seconds between the time that Amazon Route 53 gets a response from your endpoint and the time that it sends the next health-check request. Defaults to 30."
  default     = "30"
}

variable "r53_healthcheck_stringmatch" {
  description = "String searched in the first 5120 bytes of the response body for check to be considered healthy. Defaults to Pass."
  default     = "Pass"
}

# Production

variable "prod_lb_dns_name" {
  description = "DNS domain name for a CloudFront distribution, S3 bucket, ELB, or another resource record set in this hosted zone."
  default     = ""
}

variable "prod_lb_dns_zone" {
  description = "Hosted zone ID for a CloudFront distribution, S3 bucket, ELB, or Route 53 hosted zone."
  default     = ""
}

# Fallback

variable "fallback_lb_dns_name" {
  description = "DNS domain name for a CloudFront distribution, S3 bucket, ELB, or another resource record set in this hosted zone."
  default     = ""
}

variable "fallback_lb_dns_zone" {
  description = "Hosted zone ID for a CloudFront distribution, S3 bucket, ELB, or Route 53 hosted zone."
  default     = ""
}
