# F5 Distributed Cloud, Terraform, Github Actions..

![alt text for screen readers](/images/xc-to-public-ip.png "Logical diagram of F5 Distributed Cloud test scenario")

See https://f5.com/cloud for product details and https://registry.terraform.io/providers/volterraedge/volterra/latest/docs for Terraform provider useage.

This project provides an example CI/CD pipeline WAF (Web Application Firewall) deployment and automatic policy tuning within a closed test environment using F5 Distributed Cloud.  

In this demonstration scenario a WAF is deployed into a secure test environment and 'good' traffic sent to the app, via the WAF, to ensure that the WAF does not inadvertently block.  If the WAF blocks anything, it is considered to be false-positive and is likely to adversely affect the functionality of the application. A decision must be made between 'speed' (loosen the WAF policy by creating an exception rule) and 'security' (request that the application is remediated).

If the choice is 'speed' then this project shows how a Github Actions Terraform workflow can run tests through a WAF, get the security events generated during the tests, and automatically create WAF exception rules.  There is also the option to move rules created automatically into a mandatory list, so that they are permenantly stored within the configuration. 

If the choice is 'security' then the rule should not become mandatory; the application should be remediated instead.

## How to use this project:

- 1. clone the repo
- 2. update the `vars.auto-tfvars` file to suit your environment
- 3. start 'run'
    - make a code change
    - `git add .`
    - `git commit -m "my message"`
    - `git push`   
        - `git push` causes the Github Actions workflow to trigger.
    - the Github Actions workflow will run
    - `git pull` to get the updated files
    - repeat from [3] for next 'run', in acordance with Example workflows below.

## Example workflow 1

- during first run
    - create a LB & WAF on F5 Distributed Cloud Regional Edges, with an Origin pointing at another public site.
    - result is LB & WAF with no exceptions

- during second run:
    - record start timestamp, run tests against app, record end timestamp
    - the tests intentionally generate two WAF security violations
    - get security violations between timestamps, use the violations to generate two automatic WAF exception rules and apply them to the LB
    - result is LB & WAF with two automatically generated exception rules

- during third run:
    - record start timestamp, run tests against app, record end timestamp
    - this time, the tests do not trigger WAF security events, because exception rules exist
    - result is functioning application, with no WAF false-positives

- Subsequent runs should flip/flop between 'successful test' and 'waf blocked test', because the runs also flip/flop between 'add exceptions to LB' and 'remove expections from LB'

- To reset the workflow:
    - manually remove LB, Origin and WAF in XC. 
    - If exists, remove the content inside the braces `[]` in `waf_exclusion_rules = []` in the `vars.excl-rules.auto.tfvars` file
    - If exists, remove the content inside the braces `[]` in ` default = []` in the `vars.excl-rules-mandatory.tf`

## Example Workflow 2

- during first run:
    - create a LB & WAF on F5 Distributed Cloud Regional Edges, with an Origin pointing at another public site.

- before second run:
    - comment out one of the curl tests in `./.github/workflows/terraform.yml`

- during second run:
    - record start timestamp, run tests against app, record end timestamp
    - the test intentionally generates 1 x WAF security violation
    - get security violations between timestamps, use the violations to generate 1 x automatic WAF exception rule and apply to the LB
    - result is LB & WAF with one automatically generated exception rule

- before third run:
    - uncomment the curl test you previously commented out, in ./.github/workflows/terraform.yml
    - remove the content inside the braces `[]` in `waf_exclusion_rules = []` in the `vars.excl-rules.auto.tfvars` file and paste inside the braces `[]` in ` default = []` in the `vars.excl-rules-mandatory.tf` file.  This becomes a madatory rule that will persist in the configuration.

- during third run:
    - record start timestamp, run tests against app, record end timestamp
    - one test (that you just uncommented) intentionally generates 1 x new WAF security violation.  The other test does not generate WAF violation because there is now a mandatory WAF exception rule for that.
    - get security violations between timestamps, use the violations to generate 1 x automatic WAF exception rule and apply to the LB
    - result is WAF with one mandatory and one automatic exception rule.

- To reset the workflow:
    - git pull
    - If exists, remove the content inside the braces `[]` in `waf_exclusion_rules = []` in the `vars.excl-rules.auto.tfvars` file
    - If exists, remove the content inside the braces `[]` in ` default = []` in the `vars.excl-rules-mandatory.tf`
    - git add .; git commit -m "reset config"; git push

- To reset the workflow AND remove the LB/Origin:
    - manually remove LB, Origin and WAF in XC. 
    - If exists, remove the content inside the braces `[]` in `waf_exclusion_rules = []` in the `vars.excl-rules.auto.tfvars` file
    - If exists, remove the content inside the braces `[]` in ` default = []` in the `vars.excl-rules-mandatory.tf`
