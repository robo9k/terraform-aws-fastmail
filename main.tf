data "aws_route53_zone" "default" {
  zone_id = var.zone_id
}

locals {
  domain = var.subdomain == "" ? data.aws_route53_zone.default.name : "${var.subdomain}.${data.aws_route53_zone.default.name}"
  mx = [
    { value = "in1-smtp.messagingengine.com", priority = 10 },
    { value = "in2-smtp.messagingengine.com", priority = 20 },
  ]
}

resource "aws_route53_record" "mx" {
  zone_id = data.aws_route53_zone.default.id
  name    = local.domain
  type    = "MX"
  ttl     = var.ttl

  records = toset([for mx in local.mx : "${mx.priority} ${mx.value}"])
}

resource "aws_route53_record" "mx_wildcard" {
  zone_id = data.aws_route53_zone.default.id
  name    = "*.${local.domain}"
  type    = "MX"
  ttl     = var.ttl

  records = toset([for mx in local.mx : "${mx.priority} ${mx.value}"])

  lifecycle {
    enabled = var.wildcard
  }
}

resource "aws_route53_record" "dkim" {
  for_each = toset(["fm1", "fm2", "fm3"])

  zone_id = data.aws_route53_zone.default.id
  name    = "${each.key}._domainkey.${local.domain}"
  type    = "CNAME"
  ttl     = var.ttl
  records = ["${each.value}.${local.domain}.dkim.fmhosted.com"]
}

resource "aws_route53_record" "spf" {
  zone_id = data.aws_route53_zone.default.id
  name    = local.domain
  type    = "TXT"
  ttl     = var.ttl
  records = [var.spf]
}

resource "aws_route53_record" "dmarc" {
  zone_id = data.aws_route53_zone.default.id
  name    = "_dmarc.${local.domain}"
  type    = "TXT"
  ttl     = var.ttl
  records = [var.dmarc]
}

resource "aws_route53_record" "submission" {
  zone_id = data.aws_route53_zone.default.id
  name    = "_submission._tcp.${local.domain}"
  type    = "SRV"
  ttl     = var.ttl
  records = ["0 0 0 ."]
}

resource "aws_route53_record" "submissions" {
  zone_id = data.aws_route53_zone.default.id
  name    = "_submissions._tcp.${local.domain}"
  type    = "SRV"
  ttl     = var.ttl
  records = ["0 1 465 smtp.fastmail.com"]
}

resource "aws_route53_record" "imap" {
  zone_id = data.aws_route53_zone.default.id
  name    = "_imap._tcp.${local.domain}"
  type    = "SRV"
  ttl     = var.ttl
  records = ["0 0 0 ."]
}

resource "aws_route53_record" "imaps" {
  zone_id = data.aws_route53_zone.default.id
  name    = "_imaps._tcp.${local.domain}"
  type    = "SRV"
  ttl     = var.ttl
  records = ["0 1 993 imap.fastmail.com"]
}

resource "aws_route53_record" "pop3" {
  zone_id = data.aws_route53_zone.default.id
  name    = "_pop3._tcp.${local.domain}"
  type    = "SRV"
  ttl     = var.ttl
  records = ["0 0 0 ."]
}

resource "aws_route53_record" "pop3s" {
  zone_id = data.aws_route53_zone.default.id
  name    = "_pop3s._tcp.${local.domain}"
  type    = "SRV"
  ttl     = var.ttl
  records = ["10 1 995 pop.fastmail.com"]
}

resource "aws_route53_record" "jmap" {
  zone_id = data.aws_route53_zone.default.id
  name    = "_jmap._tcp.${local.domain}"
  type    = "SRV"
  ttl     = var.ttl
  records = ["0 1 443 api.fastmail.com"]
}

resource "aws_route53_record" "autodiscover" {
  zone_id = data.aws_route53_zone.default.id
  name    = "_autodiscover._tcp.${local.domain}"
  type    = "SRV"
  ttl     = var.ttl
  records = ["0 1 443 autodiscover.fastmail.com"]
}

resource "aws_route53_record" "carddav" {
  zone_id = data.aws_route53_zone.default.id
  name    = "_carddav._tcp.${local.domain}"
  type    = "SRV"
  ttl     = var.ttl
  records = ["0 0 0 ."]
}

resource "aws_route53_record" "carddavs" {
  zone_id = data.aws_route53_zone.default.id
  name    = "_carddavs._tcp.${local.domain}"
  type    = "SRV"
  ttl     = var.ttl
  records = ["0 1 443 carddav.fastmail.com"]
}

resource "aws_route53_record" "caldav" {
  zone_id = data.aws_route53_zone.default.id
  name    = "_caldav._tcp.${local.domain}"
  type    = "SRV"
  ttl     = var.ttl
  records = ["0 0 0 ."]
}

resource "aws_route53_record" "caldavs" {
  zone_id = data.aws_route53_zone.default.id
  name    = "_caldavs._tcp.${local.domain}"
  type    = "SRV"
  ttl     = var.ttl
  records = ["0 1 443 caldav.fastmail.com"]
}
