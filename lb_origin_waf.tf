resource "volterra_origin_pool" "origin" {
  name                   = format("%s-git-act-tf", var.shortname)
  namespace              = var.namespace
  description            = "Terraform created origin pool"
  loadbalancer_algorithm = "LB_OVERRIDE"

  origin_servers {
    public_name {
      dns_name = var.origin_fqdn
    }
  }
  port               = var.origin_port
  endpoint_selection = "LOCAL_PREFERRED"
  use_tls {
    no_mtls                  = true
    skip_server_verification = true
    tls_config {
      default_security = true
    }
    use_host_header_as_sni = true
  }
}

resource "volterra_http_loadbalancer" "lb" {
  name        = format("%s-git-act-tf", var.shortname)
  namespace   = var.namespace
  description = "Created by Terraform"
  domains     = [var.domain]
  depends_on  = [local_file.waf_exclusion_rules_defined_within_interval]

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

  dynamic "waf_exclusion_rules" {
    # for_each = var.waf_exclusion_rules
    for_each = jsondecode(data.jq_query.json_parser.result != "null" ? data.jq_query.json_parser.result : "[]")
    content {
      exclude_rule_ids = []
      metadata {
        name = "waf-exlusion-rule-${substr(uuid(), 0, 7)}"
      }
      exact_value = waf_exclusion_rules.value.host
      methods     = [waf_exclusion_rules.value.method]
      path_regex  = waf_exclusion_rules.value.path
      app_firewall_detection_control {
        exclude_signature_contexts {
          signature_id = waf_exclusion_rules.value.signature_id
        }
      }
    }
  }

  dynamic "waf_exclusion_rules" {
    for_each = var.waf_exclusion_rules_mandatory
    content {
      exclude_rule_ids = []
      metadata {
        name = "mandatory-waf-exlusion-rule-${substr(uuid(), 0, 7)}"
      }
      exact_value = waf_exclusion_rules.value.host
      methods     = [waf_exclusion_rules.value.method]
      path_regex  = waf_exclusion_rules.value.path
      app_firewall_detection_control {
        exclude_signature_contexts {
          signature_id = waf_exclusion_rules.value.signature_id
        }
      }
    }
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
  # detection_settings {
  #   signature_selection_setting {
  #     default_attack_type_settings = true
  #     high_medium_low_accuracy_signatures = true
  #   }
  #   enable_suppression = true
  #   enable_threat_campaigns = true
  #   default_violation_settings = true
  # }
  use_loadbalancer_setting   = true
}
