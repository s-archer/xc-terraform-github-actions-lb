
resource "volterra_api_credential" "api" {
  name                = format("%s-api-token", var.shortname)
  api_credential_type = "API_TOKEN"

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOF
      #!/bin/bash
      NAME=$(curl --location --request GET 'https://f5-emea-ent.console.ves.volterra.io/api/web/namespaces/system/api_credentials' \
        --header 'Authorization: APIToken ${self.data}'| jq 'first(.items[] | select (.name | contains("${self.name}")) | .name)') 
      curl --location --request POST 'https://f5-emea-ent.console.ves.volterra.io/api/web/namespaces/system/revoke/api_credentials' \
        --header 'Authorization: APIToken ${self.data}' \
        --header 'Content-Type: application/json' \
        -d "$(jq -n --arg n "$NAME" '{"name": $n, "namespace": "system" }')"
    EOF
  }
}

data "http" "volterra_get_blocked_by_waf" {
  provider = http-full

  url    = local.api_get_security_events_url
  method = "POST"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = format("APIToken %s", volterra_api_credential.api.data)
  }
  request_body = jsonencode({ aggs : {}, end_time : var.timestamp_end, limit : 0, namespace : var.namespace, query : "{calculated_action=\"block\", authority=\"${var.domain}\",sec_event_type=\"waf_sec_event\"}", scroll : false, sort : "DESCENDING", start_time : var.timestamp_start })
}

data "jq_query" "json_parser" {
  depends_on = [data.http.volterra_get_blocked_by_waf]

  data  = data.http.volterra_get_blocked_by_waf.body
  query = "[.events[] | fromjson | select( .signatures != {} ) | { signature_id: .signatures[].id, method: .method, path: .req_path, host: .authority } ] | unique"
}

resource "local_file" "waf_exclusion_rules_defined_within_interval" {
  content  = format("waf_exclusion_rules = %s", data.jq_query.json_parser.result != "null" ? data.jq_query.json_parser.result : "[]")
  filename = "vars.excl-rules.auto.tfvars"
}