# Multicloud-AI-Chatbot-with-OCI-ATP-Azure

How to build AI Chatbot with OCI ATP Database on Azure Cloud. I have divided into three sections:
1. OCI
2. Azure
3. Terraform.

   
High Level Architecture for OCI:
Autonomous Database (ATP) -> main data + embeddings store.
Oracle Object Storage -> for document ingestion.
OCI AI / Functions -> data preprocessing or integration logic.
Networking + IAM -> as per OCI landing zones.

High Level Architecture for Azure:
Compute / Chatbot runtime	-> Azure Container Apps or App Service (Free Tier)	-> It runs RAG inference endpoint
Embeddings / LLM	-> Azure OpenAI (Free Tier)	-> For embedding + completion
Vector store -> Azure Cognitive Search (Free)	-> For retrieval layer
Storage (Docs / PDFs)	-> Azure Blob Storage (Free)	-> For file ingestion
Identity / Access	-> Azure AD + Managed Identity -> For Terraform-managed service principal

High Level Architecture for Terraform:
terraform-oci-multicloud-azure/
  ├── modules/
  │   ├── oci/
  │   └── azure/
  │       ├── main.tf
  │       ├── variables.tf
  │       ├── outputs.tf
  ├── tutorials/
  │   └── atp-rag-chatbot/
  │       ├── main.tf
  │       ├── provider.tf
  │       ├── variables.tf
  │       └── README.md

  Terraform providers:
  terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "oci" {
  tenancy_ocid        = var.oci_tenancy_ocid
  user_ocid           = var.oci_user_ocid
  fingerprint         = var.oci_fingerprint
  private_key_path    = var.oci_private_key_path
  region              = var.oci_region
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
}

Azure module (modules/azure/main.tf)

Creates the Azure side resources:
resource "azurerm_resource_group" "rg" {
  name     = "rg-rag-chatbot"
  location = "West US 2"
}

resource "azurerm_storage_account" "sa" {
  name                     = "ragchatbotstore${random_id.suffix.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "docs" {
  name                  = "documents"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_cognitive_account" "openai" {
  name                = "ragchatbot-openai"
  location            = azurerm_resource_group.rg.location
  kind                = "OpenAI"
  sku_name            = "S0"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_app_service_plan" "plan" {
  name                = "ragchatbot-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "app" {
  name                = "ragchatbot-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id
  site_config {
    app_settings = {
      "AZURE_OPENAI_ENDPOINT" = azurerm_cognitive_account.openai.endpoint
    }
  }
}

OCI ↔ Azure Integration

We’ll create an OCI Object Storage pre-authenticated URL that the Azure chatbot can use to fetch documents, and optionally expose the ADB via private endpoint for embeddings retrieval.

Terraform can output:
output "adb_connect_string" {
  value = oci_database_autonomous_database.adb.connection_strings[0].all_connection_strings
}
output "azure_app_url" {
  value = azurerm_app_service.app.default_site_hostname
}
Deployment Steps..
Clone the repo.
Configure credentials for both providers Oracle OCI and Microsoft Azure:
export ARM_CLIENT_ID=<service_principal_id>
export ARM_CLIENT_SECRET=<service_principal_secret>
export ARM_TENANT_ID=<tenant_id>
export ARM_SUBSCRIPTION_ID=<subscription_id>
Run:
terraform init
terraform apply

Once deployed, chatbot app runs on Azure App Service using OCI ADB as backend for RAG.

As part of artifacts, refer 
Terraform folder (terraform-oci-multicloud-azure/adbs-rag-chatbot)

README.md — step-by-step deployment guide.
Azure ↔ OCI variable mappings file.
Python chatbot app template.

All the artifacts - terraform-oci-multicloud-azure.zip
It contains:
Fully documented OCI + Azure modules
Tutorial folder with provider setup, main Terraform file, variables, outputs, and README
Placeholder architecture diagram (diagrams/architecture.png)
This is ready to be pushed to a repository or deployed directly with terraform init + terraform apply

