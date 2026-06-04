output "mx" {
  value       = toset([for mx in local.mx : mx.value])
  description = "MX record values."
}
