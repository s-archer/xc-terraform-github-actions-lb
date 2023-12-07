resource "volterra_origin_pool" "origin" {
  name                   = format("%s-git-actions-tf", var.shortname)
  namespace              = var.namespace
  description            = "Created by GitHub Actions Terraform"
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
  port                   = var.origin_port
  no_tls                 = true

  origin_servers {

    k8s_service {
      service_name   = var.origin_k8s_service_name
      inside_network = true

      site_locator {

        site {
          namespace = "system"
          name      = var.origin_site
        }
      }
    }
  }
}


resource "volterra_http_loadbalancer" "lb" {
  name        = format("%s-git-actions-tf", var.shortname)
  namespace   = var.namespace
  description = "Created by GitHub Actions Terraform"
  domains     = [var.domain]

  advertise_on_public_default_vip = true
  no_challenge                    = true
  round_robin                     = true
  disable_rate_limit              = true
  no_service_policies             = true
  disable_waf                     = true
  multi_lb_app                    = true
  user_id_client_ip               = true

  https_auto_cert {
    add_hsts               = false
    http_redirect          = true
    no_mtls                = true
    default_header         = true
    disable_path_normalize = true

    tls_config {
      default_security = true
    }
  }

  default_route_pools {
    pool {
      name      = volterra_origin_pool.origin.name
      namespace = var.namespace
    }
    weight = 1
  }

  app_firewall {
    name      = volterra_app_firewall.recommended.name
    namespace = var.namespace
  }
}

resource "volterra_app_firewall" "recommended" {
  name      = format("%s-git-act-tf", var.shortname)
  namespace = var.namespace

  blocking = true

  allow_all_response_codes   = true
  default_anonymization      = true
  use_default_blocking_page  = true
  default_bot_setting        = true
  default_detection_settings = true
  use_loadbalancer_setting   = true
}
