  
provider "azurerm" {
  
  features {}
  subscription_id = "d869cbf8-8990-4e0b-94ca-9ec4e5ee2463"
  client_id       = "2e4a533b-0e77-45f3-a33b-bcde627341f6"
  client_secret   = "1lShOuES7iGdYW-~ykF~D.tT7YeYATmvoK"
  tenant_id       = "19cf5455-841e-4591-9654-f8b08846a572"
}
data "azurerm_image" "packer-image" {
  name                = "myPackerImage"
  resource_group_name = "demo-rg"
}


  resource "azurerm_network_interface" "test" {
  name                = "udacity-project-3-NIC"
  location            = "East US"
  resource_group_name = "project3-packerIMG"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  name                  = "demo-vm"
  location              = "East US"
  resource_group_name   = "project3-packerIMG"
  size                  = "Standard_B2s"
  admin_username        = "admin"
  source_image_id       = data.azurerm_image.packer-image.id
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

