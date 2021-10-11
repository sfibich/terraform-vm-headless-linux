variable "target_subscription_id" {
  type = string
  description = "The Azure Target Subscription Id resources will be created in. (Provided at run time or in TF_VAR_target_subscription_id enviorment variable)"

  validation {
    condition = length(var.target_subscription_id) == 36
    error_message = "The target_subscription_id does not match the length requirement."
  }
}

variable "prefix" {
	type = string
  description = "The prefix which should be used for all resources in this module"
	default = "debian"
}

variable "location" {
	type = string
  description = "The Azure Region in which all resources in this module"
	default = "eastus2"
}

variable "username" {
	type = string
	default = "adminuser"
}

variable "password" {
	type = string
	default = "P@ssw0rd1234!"
}
