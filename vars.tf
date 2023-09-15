locals {

  api_url                     = format("https://%s.%s/api", var.tenant, var.console_url)
  api_get_security_events_url = format("https://%s.%s/api/data/namespaces/%s/app_security/events", var.tenant, var.console_url, var.namespace)
}

variable "waf_exclusion_rules" {
  type = set(object({
    signature_id = string
    method       = string
    host         = string
    path         = string
  }))
  default = []
}

variable "console_url" {
  type    = string
  default = ""
}

variable "tenant" {
  type = string
}

variable "api_p12_file" {
  type = string
}

variable "namespace" {
  type = string
}

variable "shortname" {
  type = string
}

variable "origin_port" {
  type = string
}

variable "origin_ip" {
  type = string
}

variable "origin_site" {
  type = string
}

variable "origin_fqdn" {
  type = string
}

variable "domain" {
  type = string
}

variable "timestamp_start" {
  type    = string
  default = ""
}

variable "timestamp_end" {
  type    = string
  default = ""
}