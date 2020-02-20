resource "azurerm_storage_account" "st-acc" {
  name                     = format("%s%s", var.st_acc_name, var.location)
  resource_group_name      = azurerm_resource_group.rg-st.name
  location                 = azurerm_resource_group.rg-st.location
  account_tier             = var.storage_account_acc_tier
  account_replication_type = var.storage_account_account_replication_type

  tags = {
    environment = var.env
  }

  depends_on = ["azurerm_resource_group.rg-st"]
}
