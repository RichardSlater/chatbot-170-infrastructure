resource "azurerm_resource_group" "dev" {
  name     = "amido-uks-cb170-rg-bot-dev"
  location = "UK South"

  tags {
    environment = "Development"
  }
}

resource "azurerm_application_insights" "dev" {
  name                = "amido-uks-cb170-appinsight-bot-dev"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.dev.name}"
  application_type    = "Web"
}

resource "azurerm_key_vault" "dev" {
  name                = "amido-uks-cb170-kv-dev"
  location            = "UK South"
  resource_group_name = "${azurerm_resource_group.dev.name}"

  sku {
    name = "standard"
  }

  tenant_id = "${var.aad_tenant_id}"

  access_policy {
    tenant_id = "${var.aad_tenant_id}"
    object_id = "192a13e7-fa31-4ee1-9e1a-f7c46c9a82b6"

    key_permissions = []

    secret_permissions = [
      "get",
    ]
  }

  tags {
    environment = "Development"
  }
}

resource "azurerm_storage_account" "dev" {
  name                     = "amidoukscb170"
  resource_group_name      = "${azurerm_resource_group.dev.name}"
  location                 = "${azurerm_resource_group.dev.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  enable_blob_encryption   = "true"

  tags {
    environment = "Development"
  }
}

resource "azurerm_storage_table" "dev" {
  name                 = "development"
  resource_group_name  = "${azurerm_resource_group.dev.name}"
  storage_account_name = "${azurerm_storage_account.dev.name}"
}
