  
provider "azurerm" {
  version = ">= 2.0.0"
  features {}
  subscription_id = var.azure-subscription-id
  client_id       = var.azure-client-id
  client_secret   = var.azure-client-secret
  tenant_id       = var.azure-tenant-id
}
data "azurerm_image" "packer-image" {
  name                = "myPackerImage"
  resource_group_name = var.packer_resource_group
}

  resource "azurerm_network_interface" "test" {
  name                = "udacity-project-3-NIC"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group
  size                  = "Standard_B2s"
  admin_username        = var.admin_username
  source_image_id       = var.packer_image
  disable_password_authentication = true

  network_interface_ids = [azurerm_network_interface.test.id]
#   admin_ssh_key {
#     username   = var.admin_username
#     public_key = file(var.public_key_path)
#   }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
#  source_image_reference {
#    publisher = "Canonical"
#    offer     = "UbuntuServer"
#    sku       = "18.04-LTS"
#    version   = "latest"
  tags = {
    project_name = "QA"
    stage        = "Testing"
  }
}

