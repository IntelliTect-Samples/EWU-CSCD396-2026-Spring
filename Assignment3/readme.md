# Assignment 3

This assignment is implemented as a monorepo deployment:

- `Assignment2Webapp` is the container app users open in the browser.
- `Assignment3/FunctionApp` is the Azure Function that receives Service Bus messages.
- `Assignment3/Terraform` creates the Azure resources and managed identity permissions.
- `.github/workflows/Assignment3.yml` deploys infrastructure and application code.

## Deployed Flow

1. A user enters text on the web app home page and clicks **Send Message**.
2. The container app sends the text to the `messages` Service Bus queue.
3. The Azure Function is triggered by the same queue.
4. The Function writes the message body as a `.txt` blob in the `functionoutput` storage container.

## Assignment Checklist

- Azure Function is bound to Service Bus: `Assignment3/FunctionApp/Functions/ServiceBusMessageToBlob.cs`
- Function App has managed identity enabled: `azurerm_linux_function_app.main`
- Storage Account is created by Terraform: `azurerm_storage_account.main`
- Container App has managed identity enabled: `azurerm_container_app.main`
- Web app includes a text box and submit button: `Assignment2Webapp/Pages/Index.cshtml`
- Web app sends messages to Service Bus: `Assignment2Webapp/Pages/Index.cshtml.cs`
- Terraform state uses an Azure Storage backend: `Assignment3/Terraform/main.tf`
- GitHub Actions deploys services: `.github/workflows/Assignment3.yml`

The Function App and Container App both have system-assigned managed identities enabled. This subscription does not allow the GitHub Actions identity to create Azure role assignments, so the deployed app uses Terraform-managed Service Bus and Storage connection strings for the runtime message flow.

## GitHub Action Triggers

The Assignment 3 workflow runs on pushes to the `Assignment3` branch.

- Changes under `Assignment2Webapp/**` build and push a new container image, then update only the Azure Container App image.
- Changes under `Assignment3/Terraform/**` run `terraform init`, `terraform fmt -check`, `terraform validate`, `terraform plan`, and `terraform apply`. After Terraform succeeds, the workflow redeploys the container app code.
- Changes under `Assignment3/FunctionApp/**` publish and zip the Function project, then deploy only the Azure Function package.
- Manual runs deploy Terraform, the container app, and the Function app.

## PR Information

Add these links to the PR before submitting:

- Azure Resource Group: `https://portal.azure.com/#@/resource/subscriptions/<subscription-id>/resourceGroups/assignment3-rg/overview`
- GitHub Repository: `https://github.com/wiilke/EWU-CSCD396-2026-Spring`

Also confirm that `jcurry9@ewu.edu` has Contributor access to the Azure subscription before grading.

Recommended screenshots for the PR:

- Resource group overview showing all Assignment 3 resources.
- Container App URL loaded in the browser.
- Web app message form after a successful submit.
- Service Bus queue overview.
- Storage container showing a generated message blob.
- GitHub Actions run showing Terraform and app deployment jobs.

## Manual Test

After the workflow deploys:

1. Open the Container App URL from Terraform output `container_app_url`.
2. Enter a test message and submit it.
3. Open the `assignment3-rg` resource group in Azure.
4. Open the storage account and browse the `functionoutput` container.
5. Confirm a blob appears under `messages/YYYY/MM/DD/` and contains the submitted text.
