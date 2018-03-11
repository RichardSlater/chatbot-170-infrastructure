terraform {
  backend "azurerm" {
    resource_group_name  = "chatbot-170-tfstate-rg"
    storage_account_name = "chatbot170tfstatestor"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "dev" {
  name     = "amido-uks-chatbot170-rg-botservice-dev"
  location = "UK South"

  tags {
    environment = "Development"
  }
}

resource "azurerm_application_insights" "dev" {
  name                = "amido-uks-chatbot170-appinsight-botservice-dev"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.dev.name}"
  application_type    = "Web"
}

resource "azurerm_storage_account" "dev" {
  name                     = "amidoukscb170statestor"
  resource_group_name      = "${azurerm_resource_group.dev.name}"
  location                 = "${azurerm_resource_group.dev.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags {
    environment = "Development"
  }
}

resource "azurerm_storage_table" "dev" {
  name                 = "local"
  resource_group_name  = "${azurerm_resource_group.dev.name}"
  storage_account_name = "${azurerm_storage_account.dev.name}"
}
