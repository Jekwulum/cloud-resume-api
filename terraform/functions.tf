resource "azurerm_storage_account" "main" {
  name                     = "st${var.application_name}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}

# To store the tfstate file in a container, we need to create a container in the storage account
resource "azurerm_storage_container" "main" {
  name                  = "stcontainer${var.application_name}"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_service_plan" "main" {
  name                = "asp${var.application_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "main" {
  name                = "function${var.application_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  storage_account_name       = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key
  service_plan_id            = azurerm_service_plan.main.id
  # depends_on                 = [azurerm_service_plan.main, azurerm_storage_account.main]

  site_config {}
}