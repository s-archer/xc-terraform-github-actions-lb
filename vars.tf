locals {
  api_url = format("https://%s.%s/api", var.tenant, var.console_url)
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