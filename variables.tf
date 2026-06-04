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

variable "spf" {
  type        = string
  description = "Full value of the SPF record."
  nullable    = false
  default     = "v=spf1 include:spf.messagingengine.com ?all"
  validation {
    condition     = startswith(var.spf, "v=spf1")
    error_message = "SPF record must start with `v=spf1`"
  }
}

variable "dmarc" {
  type        = string
  description = "Full value of the DMARC record."
  nullable    = false
  default     = "v=DMARC1; p=none;"
  validation {
    condition     = startswith(var.dmarc, "v=DMARC1;")
    error_message = "DMARC record must start with `v=DMARC1;`"
  }
}
