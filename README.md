# Chatbot 170 Infrastructure

[Chatbot 170][cb17-github] is an experiment in using automotive APIs to assist motorists going about their busy daily life to get more out of their car.

## Infrastructure

Chatbot 170 is hosted in [Microsoft Azure][azure] using [Azure Kubernetes Service][aks], a high performance and high scale hosting platform for Docker workloads.  Provisioning of the required infrastructure in Azure is accomplished using [HashiCorp Terraform][tf].

### Build Pipeline

The infrastructure build pipeline utilises Shippable to provide CI/CD "as a service" this pipeline is responsible for creating all infrastructure in Azure.

### Deploying to a new Subscription

#### Configure Azure Subscription

Ensure you have the Azure CLI, or [`az`][azcli] command line, tool installed and available in your path.  The following instructions have been tested with version 2.0.28 other, you can check which version of the Azure CLI is installed and that is available in your path by issuing the following command:

    az --version

Connect the Azure CLI to Azure by logging into Azure using the command line:

    az login

Set the preferred subscription:

    az account set --subscription="${SUBSCRIPTION_ID}"

Query the Azure Active Directory tenant for the subscription:

    az account show --query "{subscriptionId:id, tenantId:tenantId}"

Create credentials for Terraform to use:

    az ad sp create-for-rbac --role="Contributor" --name="terraform-chatbot-170" --scopes="/subscriptions/${SUBSCRIPTION_ID}"

Create and encrypt your environment variables:

    ARM_SUBSCRIPTION_ID=${SUBSCRIPTION_ID} ARM_CLIENT_ID=${CLIENT_ID} ARM_CLIENT_SECRET=${CLIENT_SECRET} ARM_TENANT_ID=${TENANT_ID}

#### Bootstrap Terraform Backend

Create a resource group for the tfstate:

    az group create --location uksouth --name chatbot-170-tfstate-rg --tags lifecycle=persistent

Create a storage account for the tfstate:

    az storage account create --name chatbot170tfstatestor --resource-group chatbot-170-tfstate-rg --tags lifecycle=persistent

Get the keys for the newly created storage account:

    az storage account keys list --resource-group chatbot-170-tfstate-rg --account-name chatbot170tfstatestor

Create a container in the storage account:

    az storage container create --name tfstate --account-key ${ACCOUNT_KEY} --account-name chatbot170tfstatestor


#### Setup Azure AD Credential for Access to KeyVault

    $KEYVAULT_LOGIN = "keyvault-chatbot170"
    az account set --subscription="${ARM_SUBSCRIPTION_ID}"
    $ARM_TENANT = az account show --query "{tenantId:tenantId}" --subscription ${ARM_SUBSCRIPTION_ID} --output tsv
    $KEYVAULT_PASSWORD = az ad sp create-for-rbac --role="Contributor" --name="${KEYVAULT_LOGIN}" --scopes="/subscriptions/${ARM_SUBSCRIPTION_ID}" --query password -o tsv
    $KEYVAULT_APPID = az ad app list --display-name ${KEYVAULT_LOGIN} --query [].appId -o tsv
    az login --service-principal -u "${KEYVAULT_APPID}" -p "${KEYVALT_PASSWORD}" --tenant "${ARM_TENANT}"
    az vm list-sizes --location uksouth

  [cb170-github]: https://github.com/RichardSlater/chatbot-170
  [azure]: https://azure.microsoft.com/en-gb/
  [aks]: https://www.google.co.uk/search?q=Azure+Kubernetes+Service
  [tf]: https://www.terraform.io/
  [azcli]: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
