# F5 Distributed Cloud, Terraform, Github Actions..

![alt text for screen readers](/images/xc-to-public-ip.png "Logical diagram of F5 Distributed Cloud test scenario")

See https://f5.com/cloud for product details and https://registry.terraform.io/providers/volterraedge/volterra/latest/docs for Terraform provider useage.

This project provides an example CI/CD pipeline Load-Balancer deployment using F5 Distributed Cloud.  For a functioning sentence application, please deploy the two following terraform configurations that together create an MCN demo application that spans two sites.  The app is deployed as containers inside AWS EKS and Azure AKS:

- https://github.com/s-archer/volterra-quickdemos/tree/main/azure_site_aks_sentence
- https://github.com/s-archer/volterra-quickdemos/tree/main/aws_site_eks_colors

Note that the terraform state is stored in an Azure Storage Account.  The key for the account (and the passphrase for the automation certificate) are stored as 'Actions' Secrets in the Github Repo.

## How to use this project:

- 1. clone the repo
- 2. update the `vars.auto-tfvars` file to suit your environment
- 3. initate the create workflow:
    - `git branch dev`
    - `git checkout dev`
    - make a code change (e.g. change the filename `lb_origin.tf.delete` to `lb_origin.tf`)
    - `git add .`
    - `git commit -m "my message"`
    - `git push`   
- 4. In the Github UI, create a Pull Request to merge `Dev` into `main`
    - The `terrafom-plan.yml` Github Actions workflow will run and output the plan.
- 5. Complete the merge, which triggers the `terrafom-apply.yml` Github Actions workflow to run
        - Terraform will create the LB and Origin

## How to delete the configuration (LB and Origin)

- 1. initate the delete workflow:
    - `git checkout dev`
    - change the filename `lb_origin.tf` to `lb_origin.tf.delete`
    - `git add .`
    - `git commit -m "my message"`
    - `git push`   
- 4. In the Github UI, create a Pull Request to merge `Dev` into `main`.
    - The `terrafom-plan.yml` Github Actions workflow will run and output the plan.
- 5. Complete the merge, which triggers the `terrafom-apply.yml` Github Actions workflow to run
        - Terraform will delete the LB and Origin
