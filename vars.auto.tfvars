# F5 Distributed Cloud Tenant Details
api_p12_file = "./protected-se.p12"
console_url  = "console.ves.volterra.io"
tenant       = "f5-emea-ent"
namespace    = "s-archer"

# F5 Distributed Cloud LB Details - Per App
domain                  = "col.volt.archf5.com"
shortname               = "col-sentence"
origin_k8s_service_name = "sentence-frontend.api"
origin_fqdn             = ""
origin_ip               = ""
origin_port             = 80
origin_site             = "arch-azure-aks-site"