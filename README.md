# F5 Distributed Cloud, Terraform, Github Actions..

![alt text for screen readers](/images/workflow.png "Diagram of F5 Distributed Cloud automation workflow")

See https://f5.com/cloud for product details and https://registry.terraform.io/providers/volterraedge/volterra/latest/docs for Terraform provider useage.

This project provides an example CI/CD pipeline Load-Balancer deployment using F5 Distributed Cloud.  For a functioning sentence application, please deploy the two following terraform configurations that together create an MCN demo application that spans two sites.  The app is deployed as containers inside AWS EKS and Azure AKS:

- https://github.com/s-archer/volterra-quickdemos/tree/main/azure_site_aks_sentence
- https://github.com/s-archer/volterra-quickdemos/tree/main/aws_site_eks_colors

Note that the terraform state is stored in an Azure Storage Account.  The key for the account (and the passphrase for the automation certificate) are stored as 'Actions' Secrets in the Github Repo.

## How to use this project:

- 1. Fork this repo to your githib account and on the 'Actions' tab, make sure that GitHub Actions are enabled, by acknowledgeing the terms
- 2. Clone the repo to your local machine using the `git clone <git url>` command (you can get the git url by clicking the green `<> Code` button on the `<> Code` tab within your fork of the repo)
- 3. In your GitHub repo, go to `Settings`>`Security`>`Secrets and variables`>`Actions` and create two `Repository Secrets`:
    - `AZURE_BACKEND_KEY` containing the key value to access the Azure Storage backend (the one defined in `provider.tf`)
    - `VES_P12_PASSWORD` containing the passphrase for the F5 Distributed Cloud credential (.p12 certificate)
- 4. Update the values within the `vars.auto-tfvars` file to suit your environment
    - `api_p12_file` should point to the F5 Distributed Cloud credential (.p12 certificate)
- 5. Modify the `backend "azurerm"` configuration in `provider.tf`
- 6. initate the create workflow:
    - `git branch dev`
    - `git checkout dev`
    - make a code change (e.g. change the filename `lb_origin.tf.delete` to `lb_origin.tf`)
    - `git add .`
    - `git commit -m "my message"`
    - `git push`   
- 7. In the Github UI, create a Pull Request to merge `Dev` into `main`
    - The `terrafom-plan.yml` Github Actions workflow will run and output the plan
- 8. Review the Terraform plan that has been added to the Pull Request
- 9. Complete the merge, which triggers the `terrafom-apply.yml` Github Actions workflow to run
    - Terraform will create the LB and Origin

## How to delete the configuration (LB and Origin)

- 1. In the Github UI for this repo, navigate to the `Actions` tab
- 2. On the left menu, click `Terraform Destroy Pipeline v1`
- 3. On the right, click the `Run workflow` button, and select `Run workflow`
    - Terraform will destroy the LB and Origin
