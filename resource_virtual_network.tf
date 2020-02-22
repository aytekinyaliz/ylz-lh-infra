resource "azurerm_virtual_network" "vnet" {
  name                = format("%s-%s", var.virtual_network_name, var.location)
  location            = azurerm_resource_group.rg-net.location
  resource_group_name = azurerm_resource_group.rg-net.name
  address_space       = [var.virtual_network_address_prefix]

  subnet {
    name           = var.aks_subnet_name
    address_prefix = var.aks_subnet_address_prefix
  }

  subnet {
    name           = "appgwsubnet"
    address_prefix = var.app_gateway_subnet_address_prefix
  }

  tags       = var.tags
  depends_on = [azurerm_resource_group.rg-net]
}

data "azurerm_subnet" "kubesubnet" {
  name                 = var.aks_subnet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg-net.name

  depends_on = [azurerm_resource_group.rg-net]
}

data "azurerm_subnet" "appgwsubnet" {
  name                 = "appgwsubnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg-net.name

  depends_on = [azurerm_resource_group.rg-net]
}

# Public Ip
resource "azurerm_public_ip" "public-ip" {
  name                = format("public-ip-%s", azurerm_resource_group.rg-net.location)
  location            = azurerm_resource_group.rg-net.location
  resource_group_name = azurerm_resource_group.rg-net.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = var.project_name

  tags = var.tags

  depends_on = [azurerm_resource_group.rg-net]
}
