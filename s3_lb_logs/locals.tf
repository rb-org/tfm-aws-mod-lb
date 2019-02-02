locals {
  name_prefix = "${terraform.workspace}"
  name_suffix = "${data.aws_caller_identity.current.account_id}"

  bucket_lb_logs = "${local.name_prefix}-lb-logs-${local.name_suffix}"
}
