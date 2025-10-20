# OCI + Azure Multicloud RAG Chatbot Deployment

## Overview
Deploy a RAG chatbot using OCI Autonomous Database for embeddings and Azure OpenAI for LLM completions.

## Prerequisites
- Terraform >= 1.5
- OCI credentials: tenancy OCID, user OCID, fingerprint, private key
- Azure credentials: subscription ID, tenant ID
- Python 3.10+ for local testing

## Deployment Steps
1. Clone repository:
```bash
git clone <your-repo-url>
cd terraform-oci-multicloud-azure/tutorials/adbs-rag-chatbot
```
2. Initialize Terraform:
```bash
terraform init
```
3. Create terraform.tfvars with your credentials:
```hcl
oci_tenancy_ocid       = "<your-tenancy-ocid>"
oci_user_ocid          = "<your-user-ocid>"
oci_fingerprint        = "<your-fingerprint>"
oci_private_key_path   = "~/.oci/oci_api_key.pem"
oci_compartment_id     = "<your-compartment-ocid>"
adb_admin_password     = "<strong-password>"

azure_subscription_id  = "<your-subscription-id>"
azure_tenant_id        = "<your-tenant-id>"
```
4. Apply Terraform:
```bash
terraform apply
```
5. Access chatbot at:
```
Output: azure_app_url
```
6. Upload documents to OCI Object Storage for ingestion.

## Architecture Diagram
See ../../diagrams/architecture.png

## Notes
- Free tiers used where possible
- Ensure Azure OpenAI quota covers gpt-35-turbo usage
