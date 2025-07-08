module "xc_lb" {
  source                       = "./modules/no-code"
  f5xc_api_url                 = local.f5xc_api_url
  f5xc_api_p12_file            = var.f5xc_api_p12_file
  f5xc_namespace               = var.f5xc_namespace
  f5xc_tenant_full             = var.f5xc_tenant_full
  f5xc_lb_domains              = var.f5xc_lb_domains
  f5xc_object_name             = local.f5xc_object_name
  f5xc_origin_fqdns            = var.f5xc_origin_fqdns
  f5xc_origin_discovery        = var.f5xc_origin_discovery
  f5xc_origin_ips              = var.f5xc_origin_ips
  f5xc_origin_port             = var.f5xc_origin_port
  f5xc_origin-healthcheck-path = var.f5xc_origin-healthcheck-path
  f5xc_cloud                   = var.f5xc_cloud
  f5xc_swagger_filename        = var.f5xc_swagger_filename
  f5xc_swagger_format          = var.f5xc_swagger_format
  f5xc_cert                    = var.f5xc_cert
}