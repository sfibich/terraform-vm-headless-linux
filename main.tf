locals {
  main_tags        = merge(var.tags, var.env_tags)
  allowed_list_ips = split(",", coalesce(var.allowed_list_ips, chomp(data.http.icanhazip.body)))
}

resource "random_pet" "server" {
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-${var.machine_number}-rg"
  location = var.location
  tags     = local.main_tags
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["192.168.0.0/18"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.main_tags
}

resource "azurerm_subnet" "workstation" {
  name                 = "workstation"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["192.168.0.0/27"]
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Dynamic"
  domain_name_label   = lower(random_pet.server.id)
  tags                = local.main_tags
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.workstation.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
  tags = local.main_tags
}

resource "azurerm_network_security_group" "access" {
  name                = "${var.prefix}-workstation-access"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "ssh"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefixes    = local.allowed_list_ips
    destination_port_range     = "22"
    destination_address_prefix = azurerm_network_interface.main.private_ip_address
  }

  tags = local.main_tags
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.workstation.id
  network_security_group_id = azurerm_network_security_group.access.id
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.prefix}-${var.machine_number}-ws"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B1s"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id
  ]
  boot_diagnostics {
    storage_account_uri = null
  }

  custom_data = base64encode(file("cloud-init-debian-11.sh"))

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11"
    version   = "0.20210814.734"
  }

  os_disk {
    storage_account_type   = "Standard_LRS"
    caching                = "ReadWrite"
    disk_encryption_set_id = azurerm_disk_encryption_set.vm.id
  }

  tags = local.main_tags
}


resource "azurerm_dev_test_global_vm_shutdown_schedule" "workstation" {
  virtual_machine_id = azurerm_linux_virtual_machine.main.id
  location           = azurerm_resource_group.main.location
  enabled            = true

  daily_recurrence_time = "2230"
  timezone              = "Eastern Standard Time"

  notification_settings {
    enabled = false
  }
}

