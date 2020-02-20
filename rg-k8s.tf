resource "azurerm_resource_group" "rg-k8s" {
  name     = format("%s-%s", var.resource_group_name_k8s, var.location)
  location = var.location

  tags = {
    environment = var.env
  }
}
