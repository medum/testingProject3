resource "azurerm_virtual_network" "test" {
  name                 = "test-ntwrk"
  address_space        = var.address_space
  location             = var.location
  resource_group_name  = var.resource_group
}
resource "azurerm_subnet" "test" {
  name                 = "test-ntwrk-sub"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes       = ["10.0.1.0/24"]
}
