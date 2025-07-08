resource "restful_resource" "api-spec" {
  provider      = restful.f5_xc_api
  create_method = "PUT"
  path          = format(var.f5xc_api_spec_swagger_uri, var.f5xc_namespace, var.f5xc_object_name)
  read_path     = format(var.f5xc_api_spec_object_uri, var.f5xc_namespace, var.f5xc_object_name)
  update_path   = format(var.f5xc_api_spec_swagger_uri, var.f5xc_namespace, var.f5xc_object_name)
  delete_path   = format(var.f5xc_api_spec_object_uri, var.f5xc_namespace, var.f5xc_object_name)

  poll_create = {
    status_locator = "code"
    status = {
      success = "200"
    }
  }

  poll_delete = {
    status_locator = "code"
    status = {
      success = "404"
    }
  }

  header = {
    Content-Type = format("application/%s", var.f5xc_swagger_format)
  }

  body = {
    name           = var.f5xc_object_name
    namespace      = var.f5xc_namespace
    string_value   = file(format("%s/%s", "${path.root}", var.f5xc_swagger_filename))
    content_format = var.f5xc_swagger_format
    object_type    = "swagger"
  }

  lifecycle {
    ignore_changes = [
      body.name,
      body.namespace,
      body.object_type

    ]
  }
}


data "http" "api-spec" {
  depends_on = [restful_resource.api-spec]
  url        = format(var.f5xc_api_spec_base_uri, var.f5xc_api_url, var.f5xc_namespace)
  request_headers = {
    Accept        = "application/json"
    Authorization = format("APIToken %s", volterra_api_credential.api-creds.data)
  }
}


locals {
  f5xc_swagger_url = [
    for item in jsondecode(data.http.api-spec.response_body).items :
    try([
      for version in item.versions : version if version.latest_version][0].url, null
    )
    if item.name == "${var.f5xc_namespace}/${var.f5xc_object_name}"
  ]
}


resource "volterra_api_definition" "api-def" {
  depends_on           = [data.http.api-spec]
  name                 = var.f5xc_object_name
  namespace            = var.f5xc_namespace
  strict_schema_origin = true
  swagger_specs        = local.f5xc_swagger_url

  lifecycle {
    ignore_changes = [
      annotations,
      disable,
      labels
    ]
  }
}