# StrongSwan Infrastructure

This repo contains Terraform IaC to create the server necessary for the StrongSwan connection.

## Install

- Set up the AWS CLI with your user account for programmatic access. Ensure it has that user has the sufficient permisisons (EC2, VPC, etc).
- Set up Terraform
- Run the *create_key_pair.sh* to generate a pair of EC2 keys. It will call on the AWS CLI for that, creating a key-pair and storing one in EC2 while producing the other. Note that this is the one part not part of the IaC and will not be destroyed by `terraform destroy`.  The name "SS_EC2_key" has been hard-coded into both *create_key_pair.sh*, *destroy_key_pair* and the *variables.tf*. 
- Run `terraform init` and then `terraform apply` to create a VPC with a simple public subnet containing an Ubuntu instance. The *variables.tf* file has been pre-filled with the correct info for the Ubuntu LTS version 20 in the EU-NORTH-1 region. Adjust that as applicable if you're going to set the instance up in a different region, or if you want to change the AMI.
  