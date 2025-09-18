variable "cloud_map" {
  default = {
    azure = "arch-azure-smsv2-vt-prov-site-cc60-node-0"
    aws   = "arch-aws-juice-site"
  }
}

variable "f5xc_api_spec_base_uri" {
  type    = string
  default = "%s/object_store/namespaces/%s/stored_objects/swagger"
}

variable "f5xc_api_spec_swagger_uri" {
  type    = string
  default = "/object_store/namespaces/%s/stored_objects/swagger/%s"
}

variable "f5xc_api_spec_object_uri" {
  type    = string
  default = "/object_store/namespaces/%s/stored_objects/swagger/%s/$(body.metadata.version)"
}

variable "f5xc_object_name" {
  type = string
}

variable "f5xc_api_url" {
  type = string
}

variable "f5xc_api_p12_file" {
  type = string
}

variable "f5xc_namespace" {
  type = string
}

variable "f5xc_tenant_full" {
  type = string
}

variable "f5xc_origin_port" {
  type = string
}

variable "f5xc_origin_ips" {
  type = list(string)
}

variable "f5xc_origin_discovery" {
  type = list(string)
}

variable "f5xc_cloud" {
  type = string
}

variable "f5xc_origin_fqdns" {
  type = list(string)
}

variable "f5xc_origin-healthcheck-path" {
  type = string
}

variable "f5xc_lb_domains" {
  type = string
}

variable "f5xc_cert" {
  type = string
}

variable "f5xc_swagger_filename" {
  type = string
}

variable "f5xc_swagger_format" {
  type = string
}