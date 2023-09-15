output "jquery" {
  value = data.jq_query.json_parser.result
}

output "timestamps" {
  value = format("timestamp_start: %s, timestamp_end: %s, request body:%s, response body:%s ", var.timestamp_start, var.timestamp_end, data.http.volterra_get_blocked_by_waf.request_body, data.http.volterra_get_blocked_by_waf.body)
}