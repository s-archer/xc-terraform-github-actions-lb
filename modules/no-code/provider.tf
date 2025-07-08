terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.43"
    }
    restful = {
      source  = "magodo/restful"
      version = "0.18.0"
    }
  }
}

provider "restful" {
  alias    = "f5_xc_api"
  base_url = var.f5xc_api_url
  security = {
    apikey = [
      {
        in    = "header"
        name  = "Authorization"
        value = format("APIToken %s", volterra_api_credential.api-creds.data)
      },
    ]
  }
}

resource "volterra_api_credential" "api-creds" {
  name                = var.f5xc_object_name
  api_credential_type = "API_TOKEN"
  created_at          = timestamp()
  lifecycle {
    ignore_changes = [
      created_at
    ]
  }
}