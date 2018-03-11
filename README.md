# Chatbot 170

Chatbot 170 is an experiment in using automotive APIs to assist motorists going about their busy daily life to get more out of their car.

[![js-standard-style](https://cdn.rawgit.com/standard/standard/master/badge.svg)](http://standardjs.com)

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

Make a note of the `appId` and `password` for future use.

Login using the Azure CLI to the newly created Service Principal:

    az login --service-principal -u "terraform-chatbot-170" -p "${PASSWORD}" --tenant "${TENANT}"

Run a read-only command to validate the principal works as expected:

    az vm list-sizes --location uksouth

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

  [azure]: https://azure.microsoft.com/en-gb/
  [aks]: https://www.google.co.uk/search?q=Azure+Kubernetes+Service
  [tf]: https://www.terraform.io/
  [azcli]: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
