output "jquery" {
  value = data.jq_query.json_parser.result
}

output "timestamps" {
  value = format("timestamp_start: %s, timestamp_end: %s", var.timestamp_start, var.timestamp_end)
}