resource "volterra_http_loadbalancer" "lb" {
  name        = var.f5xc_object_name
  namespace   = var.f5xc_namespace
  description = "Pattern A1 TF deployment zero-code module"
  domains     = [var.f5xc_lb_domains]

  enable_malicious_user_detection = true
  enable_threat_mesh              = true
  add_location                    = true

  # https {
  #   port          = 443
  #   http_redirect = true
  #   add_hsts      = true

  #   tls_cert_params {
  #     no_mtls = true
  #     certificates {
  #       name      = var.f5xc_cert
  #       namespace = var.f5xc_namespace
  #     }
  #   }
  # }
  https_auto_cert {
    port          = 443
    add_hsts      = true
    http_redirect = true

    tls_config {
      default_security = true
    }
  }

  app_firewall {
    tenant    = var.f5xc_tenant_full
    namespace = "shared"
    name      = volterra_app_firewall.recommended.name
  }

  enable_challenge {
    # default_mitigation_settings = true 
    # default_js_challenge_parameters = true 
    # default_captcha_challenge_parameters = true
  }

  user_identification {
    tenant    = var.f5xc_tenant_full
    namespace = "shared"
    name      = volterra_user_identification.recommended.name
  }

  enable_ip_reputation {
    ip_threat_categories = [
      "SPAM_SOURCES",
      "WINDOWS_EXPLOITS",
      "WEB_ATTACKS",
      "BOTNETS",
      "SCANNERS",
      "REPUTATION",
      "PROXY",
      "MOBILE_THREATS",
      "TOR_PROXY",
      "DENIAL_OF_SERVICE",
      "NETWORK",
      "PHISHING"
    ]
  }

  api_specification {
    api_definition {
      tenant    = var.f5xc_tenant_full
      namespace = var.f5xc_namespace
      name      = volterra_api_definition.api-def.name
    }

    validation_all_spec_endpoints {
      fall_through_mode { 
        fall_through_mode_allow = true
      }
      validation_mode {
        validation_mode_active {
          enforcement_block = true
          request_validation_properties = [
            "PROPERTY_PATH_PARAMETERS",
            "PROPERTY_QUERY_PARAMETERS",
            "PROPERTY_HTTP_HEADERS"
          ]
        }
      }
      settings {
        oversized_body_skip_validation = true
        property_validation_settings_default = true        
      }   
    }
  }

  enable_api_discovery {
    disable_learn_from_redirect_traffic = true
    discovered_api_settings {
      purge_duration_for_inactive_discovered_apis = "2"
    }
    api_crawler {
      api_crawler_config {
        domains {
          domain = "nocode.f5xc.co.uk"
          simple_login {
            user = "user123"
            password {
              clear_secret_info {
                url = "string:///dGVzdDEyMw=="
              }
            }
          }
        }
      }
    }
  }

  default_route_pools {
    pool {
      tenant    = var.f5xc_tenant_full
      namespace = var.f5xc_namespace
      name      = volterra_origin_pool.origin.name
    }
  }

  # advertise_custom {
  #   advertise_where {
  #     site {
  #       network = "SITE_NETWORK_INSIDE"
  #       site {
  #         name      = var.cloud_map[var.f5xc_cloud]
  #         namespace = "system"
  #       }
  #     }
  #   }
  # }

  lifecycle {
    ignore_changes = [
      https_auto_cert,
      advertise_on_public_default_vip,
      default_sensitive_data_policy,
      disable_rate_limit,
      disable_trust_client_ip_headers,
      l7_ddos_action_default,
      labels,
      round_robin,
      service_policies_from_namespace,
      enable_challenge
    ]
  }
}

resource "volterra_origin_pool" "origin" {
  name                   = var.f5xc_object_name
  namespace              = var.f5xc_namespace
  description            = "Pattern A1 TF deployment zero-code module"
  loadbalancer_algorithm = "LB_OVERRIDE"

  dynamic "origin_servers" {
    for_each = var.f5xc_origin_ips
    content {
      private_ip {
        ip             = origin_servers.value
        inside_network = true
        site_locator {
          site {
            name      = var.cloud_map[var.f5xc_cloud]
            namespace = "system"
          }
        }
      }
    }
  }

  dynamic "origin_servers" {
    for_each = var.f5xc_origin_fqdns
    content {
      private_name {
        dns_name         = origin_servers.value
        refresh_interval = "60"
        inside_network   = true
        site_locator {
          site {
            name      = var.cloud_map[var.f5xc_cloud]
            namespace = "system"
          }
        }
      }
    }
  }

  dynamic "origin_servers" {
    for_each = var.f5xc_origin_discovery
    content {
      consul_service {
        inside_network = true
        service_name   = origin_servers.value
        site_locator {
          site {
            name      = var.cloud_map[var.f5xc_cloud]
            namespace = "system"
          }
        }
      }
    }
  }

  port               = var.f5xc_origin_port
  endpoint_selection = "LOCAL_PREFERRED"
  # no_tls             = true
  use_tls {
    no_mtls                  = true
    skip_server_verification = true
    tls_config {
      default_security = true
    }
    use_host_header_as_sni = true
  }

  healthcheck {
    name      = volterra_healthcheck.healthcheck.name
    namespace = var.f5xc_namespace
  }
  lifecycle {
    ignore_changes = [
      healthcheck[0].tenant,
      origin_servers[0].consul_service
      # origin_servers,
      # use_tls
    ]
  }
}

resource "volterra_healthcheck" "healthcheck" {
  name      = var.f5xc_object_name
  namespace = var.f5xc_namespace

  http_health_check {
    use_origin_server_name = true
    path                   = var.f5xc_origin-healthcheck-path
    use_http2              = false
    headers = {
      Connection = "close"
    }
    request_headers_to_remove = [
      "user-agent"
    ]
  }

  healthy_threshold   = 3
  interval            = 15
  timeout             = 3
  unhealthy_threshold = 1
}

resource "volterra_app_firewall" "recommended" {
  name      = var.f5xc_object_name
  namespace = "shared"

  blocking = true

  allow_all_response_codes   = true
  default_anonymization      = true
  use_default_blocking_page  = true
  default_detection_settings = true
}

resource "volterra_user_identification" "recommended" {
  name      = var.f5xc_object_name
  namespace = "shared"

  rules {

    ip_and_ja4_tls_fingerprint = true
  }
}

#  This is for the colors microservice

# resource "volterra_http_loadbalancer" "colors" {
#   name        = "sentence-colors-nocode"
#   namespace   = var.f5xc_namespace
#   description = "Colours microservice designed to decorate a sentence"
#   domains     = ["sentence-colors.azure-aks"]
#   #domains     = ["sentence-colors.api"]
  
#   http {
#     dns_volterra_managed = false
#     port                 = "80"
#   }

#   advertise_custom {
#     advertise_where {
#       site {
#         network = "SITE_NETWORK_INSIDE"
#         site {
#           namespace = "system"
#           name      = var.cloud_map[var.f5xc_cloud]
#         }
#       }
#     }
#   }

#   default_route_pools {
#     pool {
#       namespace = var.f5xc_namespace
#       name      = volterra_origin_pool.colors.name
#     }
#   }
# }

# resource "volterra_origin_pool" "colors" {
#   name                   = "sentence-colors-nocode"
#   namespace              = var.f5xc_namespace
#   description            = "Colours microservice designed to decorate a sentence"
#   endpoint_selection     = "LOCAL_PREFERRED"
#   loadbalancer_algorithm = "LB_OVERRIDE"
#   port                   = 80
#   no_tls                 = true

#   origin_servers {

#     k8s_service {
#       service_name   = "sentence-colors.aws-eks"
#       inside_network = true

#       site_locator {

#         site {
#           namespace = "system"
#           name      = "arch-smsv1-aws-eks-site"
#         }
#       }
#     }
#   }
# }