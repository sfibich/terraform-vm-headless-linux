# Debian 11 Headless Linux Workstation

This terraform script creates an Azure Debian 11 with all the bells and whistles need to be the perfect headless workstation.

## Configuration and Installed Software:

* set time zone to America/New_York
* Terminal Manager/Multiplexer - tmux
* Vim Python 3 support - vim-vox
* Vim Code Completion - You Complete Me
* Infrastructure as code tools - Terraform
* Azure Tools - AZ CLI
* Azure Tools - Powershell w/ AZ module
* Python 3.9 Development Tools
* java

## Azure Configuration

## Examples

### Example 1:

The following would prompt to approve the plan and use the default password provided in the variables file.  This is not recommended as the password is exposed in this repository.

`
terraform apply --var-file env/prod.tfvars
`

### Example 2:

The following would automatically approve the plan and use the password N3wP@ssw0rd inplace of the default password provided in the variables file.

`
terraform apply --auto-approve --var-file env/prod.tfvars -var="password=N3wP@ssw0rd"
`
