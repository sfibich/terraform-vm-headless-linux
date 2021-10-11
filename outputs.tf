output "shell_station_dns_name" {
  value=azurerm_public_ip.pip.domain_name_label
}



output "final_message" {
  value="The Cloud Init script can take a few minutes to complete"
}
