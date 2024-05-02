resource "azurerm_virtual_network" "prod_vnet" {
  name                = "prod-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.prod_rg.location
  resource_group_name = azurerm_resource_group.prod_rg.name
}

resource "azurerm_subnet" "prod_subnet" {
  name                 = "prod-subnet"
  resource_group_name  = azurerm_resource_group.prod_rg.name
  virtual_network_name = azurerm_virtual_network.prod_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
