provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}
terraform {
  required_version = ">=0.15.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.50.0"
    }
  }
  backend "azurerm" {
    storage_account_name = "cs2100320013d36b995"
    container_name       = "demo-container"
    key                  = "key1"
    access_key           = "JjsRDd9vZKY3u0c5kDt2z/AF1yW7RUGBPG/VGA1q7zQdfb5KIOcgln9U7rA+VqA/gfX4AE8/GMDP+9PSUPl5uA=="
  }
}
module "resource_group" {
  source         = "./modules/resource_group"
  resource_group = var.resource_group
  location       = var.location
}
module "network" {
  source               = "./modules/network"
  location             = var.location
  address_space        = ["10.5.0.0/16"]
  virtual_network_name = var.virtual_network_name
  application_type     = var.application_type
  resource_type        = "NET"
  resource_group       = module.resource_group.resource_group_name
  address_prefix_test  = var.address_prefix_test
}

module "nsg-test" {
  source              = "./modules/networksecuritygroup"
  location            = var.location
  application_type    = var.application_type
  resource_type       = "NSG"
  resource_group      = module.resource_group.resource_group_name
  subnet_id           = module.network.subnet_id_test
  address_prefix_test = var.address_prefix_test
}
module "appservice" {
  source           = "./modules/appservice"
  location         = var.location
  application_type = var.application_type
  resource_type    = "AppService"
  resource_group   = module.resource_group.resource_group_name
}
module "publicip" {
  source           = "./modules/publicip"
  location         = var.location
  application_type = var.application_type
  resource_type    = "publicip"
  resource_group   = module.resource_group.resource_group_name
}

module "vm" {
  source          = "./modules/vm"
  name            = "vm-test-automation"
  location        = var.location
  subnet_id       = module.network.subnet_id_test
  resource_group  = module.resource_group.resource_group_name
  public_ip       = module.publicip.public_ip_address_id
  admin_username  = var.admin_username
  packer_image    = var.packer_image
  public_key_path = var.public_key_path
}
