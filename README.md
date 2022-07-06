# Module name using following format (<provider>-terraform-<description>, example: azure-terraform-vnet) 

<Module description>

It supports creating:

- list resources created by module

<Describe any submodules> 

## Usage Examples
You can go to the tests folder, or review the examples folder: [examples](./examples)


## Deployment
Perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure



< use terraform-docs to create Inputs and Outpus documentation >  [terraform-docs](https://github.com/terraform-docs/terraform-docs)

`terraform-docs markdown .`


## Requirements
### Installed Software
The following dependencies must be installed on the development system:

- [Terraform](https://www.terraform.io/downloads.html) 

Azure  
- [Terraform Provider for Azure](https://github.com/hashicorp/terraform-provider-azurerm)
- CLI Tool [az](https://docs.microsoft.com/en-us/cli/azure/)

AWS  
- [Terraform Provider for AWS](https://github.com/hashicorp/terraform-provider-aws)
- CLI Tool [aws-cli](https://aws.amazon.com/cli/)

GCP  
- [Terraform Provider for GCP](https://github.com/hashicorp/terraform-provider-google)
- [Terraform Provider for GCP Beta](https://github.com/terraform-providers/terraform-provider-google-beta)
- CLI Tool [gcloud](https://cloud.google.com/sdk/gcloud/)


<Any configuration needed on cloud plartform such as:>
- Service Principals
- IAM Roles
- Service Accounts


## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.
