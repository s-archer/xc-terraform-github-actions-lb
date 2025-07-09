# F5 Distributed Cloud Tenant Details
# You will need to login to F5 XC Distributed Cloud to obtain an API certificate p12
#  file for automation.
f5xc_api_p12_file = "./protected-se.p12"
f5xc_tenant       = "f5-emea-ent"
f5xc_tenant_full  = "f5-emea-ent-bceuutam"
f5xc_namespace    = "s-archer"

# Choose a unique prefix/suffix for object names (suggest a short version of application name)
f5xc_prefix = "arch"
f5xc_suffix = "nocode-example"

# F5 Distributed Cloud LB Details - Per App
# Configure the LB name, the domain the LB will listen on (match Host header) 
#  and the site where the LB will be created.
# f5xc_lb_domains = "nocode.archf5.com"
f5xc_lb_domains = "nocode.f5xc.co.uk"
f5xc_cert       = "arch-nocode-f5xc-co-uk"

# If using an API swagger file, upload into the terraform root folder (same folder as this 
#  readme) and add the name of the file here.  And set fromat to either "json" or "yaml".
f5xc_swagger_filename = "swagger-juice-v1.json"
f5xc_swagger_format   = "json"

# Configure the upstream target origin servers (and port), where we will send  
#  requests.
#  You can configure either an INTERNAL FQDN, SERVICE DISCOVERY name or IP ADDRESSES or 
#  combination of all three.  If not required, leave the relevant list empty.
f5xc_origin_fqdns     = []
f5xc_origin_discovery = []
f5xc_origin_ips       = ["10.1.221.249", "10.2.231.100"]

f5xc_origin_port = 443

# Configure the upstream target origin servers, where we will send 
f5xc_origin-healthcheck-path = "/"

# Define the location where the origin will be created.  The value should
#  be one of the following:
#
#   aws
#   azure
#
f5xc_cloud = "azure"