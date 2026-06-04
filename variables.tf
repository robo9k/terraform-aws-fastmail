variable "zone_id" {
  type        = string
  description = "Id of the `aws_route53_zone` to create DNS records for."
  nullable    = false
}

variable "subdomain" {
  type        = string
  description = "Subdomain within zone to create DNS records for. Defaults to zone name, i.e. empty."
  nullable    = false
  default     = ""
}

variable "ttl" {
  type        = number
  description = "Time-to-live for all created DNS records."
  nullable    = false
  default     = 3600
}

variable "wildcard" {
  type        = bool
  description = "Whether to create wildcard MX records."
  nullable    = false
  default     = true
}
