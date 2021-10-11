# Ubuntu 18.04/XFCE Workstation
This terrform script create an Ubuntu 18.04 LTS machine with an XFCE desktop.
### Configuration and Installed Software:
* set time zone to America/New_York
* apt-get update & upgrade
* Desktop (XFCE w/goodies, x11 xserver utils and a few others)
* Firefox
* Password Manager Service (gnome-keyring)
* RDP (XRDP)
* Terraform
* Azure Storage Explorer
* Visual Studio Code
* java
* .Net 5.0
* Powershell
* PowerShell AZ Module
* AZ CLI

## Example 1:
The following would prompt to approve the plan and use the default password provided in the variables file.  This is not recommended as the password is exposed in this repository.

`
terraform apply
`
## Example 2:
The following would automatically approve the plan and use the password N3wP@ssw0rd inplace of the default password provided in the variables file.

`
terraform apply --auto-approve -var="password=N3wP@ssw0rd"
`
