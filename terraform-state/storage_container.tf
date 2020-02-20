resource "azurerm_storage_container" "st-con-terraform" {
  name                 = var.storage_container_name
  resource_group_name  = azurerm_resource_group.rg-st.name
  storage_account_name = azurerm_storage_account.st-acc.name

  depends_on = [azurerm_storage_account.st-acc]
}
