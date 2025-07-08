output "domain" {
  value = format("Created load-balancer for application: %s", var.f5xc_lb_domains)
}