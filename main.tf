terraform {
  backend "azurerm" {
    resource_group_name  = "chatbot-170-tfstate-rg"
    storage_account_name = "chatbot170tfstatestor"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

module "dev" {
  source = "./dev"
}
