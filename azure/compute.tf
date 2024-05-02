resource "azurerm_linux_virtual_machine" "ansible_server" {
  name                = "ansible-server"
  resource_group_name = azurerm_resource_group.prod_rg.name
  location            = azurerm_resource_group.prod_rg.location
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.ansible_nic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "ansible_nic" {
  name                = "ansible-nic"
  location            = azurerm_resource_group.prod_rg.location
  resource_group_name = azurerm_resource_group.prod_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.prod_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ansible_public_ip.id
  }
}

resource "azurerm_public_ip" "ansible_public_ip" {
  name                = "ansible-public-ip"
  location            = azurerm_resource_group.prod_rg.location
  resource_group_name = azurerm_resource_group.prod_rg.name
  allocation_method   = "Dynamic"
}
