# F5 Distributed Cloud Tenant Details
api_p12_file = "./protected-se.p12"
console_url  = "console.ves.volterra.io"
tenant       = "f5-emea-ent"
namespace    = "s-archer"

# F5 Distributed Cloud LB Details - Per App
domain                  = "sentence-cicd.archf5.com"
shortname               = "sentence-cicd"
origin_k8s_service_name = "sentence-frontend.dc1-f5-demo"
origin_fqdn             = ""
origin_ip               = ""
origin_port             = 80
origin_site             = "arch-1-nsx-single-nic-dc1-out"