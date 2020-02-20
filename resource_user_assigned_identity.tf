# User Assigned Identities
resource "azurerm_user_assigned_identity" "identity-exampleproject" {
  resource_group_name = azurerm_resource_group.rg-k8s.name
  location            = azurerm_resource_group.rg-k8s.location

  name = "identity-exampleproject"

  tags = var.tags

  depends_on = [azurerm_resource_group.rg-k8s]


}
