variable "prefix" {
  type        = string
  description = "The prefix which should be used for all resources in this module"
  default     = "debian"
}

variable "machine_number" {
  type        = string
  description = "unique machine number to be a suffix to the overall machine name and resource group"
}

variable "location" {
  type        = string
  description = "The Azure Region in which all resources in this module"
  default     = "eastus2"
}

variable "username" {
  type    = string
  default = "adminuser"
}

variable "password" {
  type    = string
  default = "P@ssw0rd1234!"
}
