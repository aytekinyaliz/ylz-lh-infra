resource "azurerm_resource_group" "rg-st" {
  name     = format("%s-%s", var.resource_group_name_storage, var.location)
  location = var.location

  tags = {
    environment = var.env
  }
}
