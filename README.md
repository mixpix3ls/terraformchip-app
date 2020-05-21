# Completed

- Stood up Terraform Enterprise
- Set up GitHub integration
- Configured hourly backups to S3
- Set up Sentinel Policy to restrict all EC2 deployments to `us-west-1` and `eu-central-1` across all workspaces
- Set up Sentinal Policy to restrict cost usage to less than 100 across all workspaces
- Enabled `Needs Attention` and `Errored` notifications (on TF Cloud)
- Bastion host created in the admin vpc but not sure if I set up networking to it properly
- Created EC2 instance with Drupal AMI but no 
- Created vpcs in us-west-1, eu-central-1 across all AZ
# Challenges I hit

* I did not have the neccessary AWS Networking skills to set up much of the VPC, Load Balancers, Peering, etc.
* I was going from recently having passed the Terraform Associate certificate and not having that much experience Terraform directly into this engagement (seemed like a heavy lift to me)
* I tried setting up Terraform Enterprise using a few of the techniques listed in the TFE module but ran into many issues. I tried both the self-signed cert method and the domain option. What ended up working for me was the self-signed method, albeit, with great help from Chris
* Setting up Terrform took the bulk of my time during the training

# What would you leave the customer with

## Terraform Enterprise

* Logs are currently stored locally on the TFE instance in EC2. For more information see the following to enable `logspout`:
  * https://www.terraform.io/docs/enterprise/admin/logging.html#application-logs

## Sentinel

### Recap interviews

* Joe really wants to keep track of where the applications are deployed so they aren’t put in insecure environments or regions that would violate their data governance requirements
* Bo needs to know which actions are going to be taken and place controls over them. He’d also like approvals over those actions. This would be “huge time savings” for him
* Kim has to manually go through a compliance checklist. It’s a ton of work to make small changes and it she feels like it’s a waste of time

The application repository contains Sentinel policies for the following:
* Restrict all EC2 instances to be deployed on `us-west-1` and `eu-central-1`
* All deployments must not exhibit more than `$100` delta increase since the last deployment

### Resources to learn Sentinel

* https://www.terraform.io/docs/cloud/sentinel/index.html
* https://www.terraform.io/docs/cloud/cost-estimation/index.html

### Repositories

Application Setup / Sentinel / Cost Estimation: https://github.com/mixpix3ls/terraformchip-app

Terraform Enterprise setup: https://github.com/mixpix3ls/terraformchip








