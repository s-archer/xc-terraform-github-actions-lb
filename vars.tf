locals {
  f5xc_api_url = format("https://%s.console.ves.volterra.io/api", var.f5xc_tenant)
}

locals {
  f5xc_object_name = format("%s-%s", var.f5xc_prefix, var.f5xc_suffix)
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_tenant" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_tenant_full" {
  type = string
}

variable "f5xc_lb_domains" {
  type = string
}

variable "f5xc_cert" {
  type = string
}

variable "f5xc_prefix" {
  type = string
}

variable "f5xc_suffix" {
  type = string
}

variable "f5xc_origin_fqdns" {
  type = list(string)
}

variable "f5xc_origin_discovery" {
  type = list(string)
}

variable "f5xc_origin-healthcheck-path" {
  type = string
}

variable "f5xc_origin_ips" {
  type = list(string)
}

variable "f5xc_origin_port" {
  type = string
}

variable "f5xc_cloud" {
  type = string
}

variable "f5xc_swagger_filename" {
  type = string
}

variable "f5xc_swagger_format" {
  type = string
}