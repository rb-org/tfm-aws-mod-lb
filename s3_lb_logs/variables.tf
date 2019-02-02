variable "tags" {
  description = "Map of tags to add to all resources"
  type        = "map"
  default     = {}
}

variable "log_rotation" {
  description = "Days before purging data. 0 is disabled."
  default     = 14
}
