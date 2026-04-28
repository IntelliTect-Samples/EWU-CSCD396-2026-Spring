# Assignment 2 - Containerized Web App

## Resource Group

[rg-assignment2-carsonl15](https://portal.azure.com/#@/resource/subscriptions/SUBSCRIPTION_ID/resourceGroups/rg-assignment2-carsonl15/overview)
<!-- Replace SUBSCRIPTION_ID above with your actual subscription ID once deployed. -->

## Live URL

_Filled in after the workflow runs successfully._

## What's here

- `WebApp/` - .NET 8 minimal-API web app, containerized with the .NET SDK container tools (`/t:PublishContainer`)
- `../Terraform/` - HCL for the resource group, Container Apps Environment, Container Registry, user-assigned identity, role assignments, and Container App
- `../.github/workflows/deploy-assignment2.yml` - three-stage deploy: bootstrap (RG + ACR) -> build & push image -> apply (Container App)

## Screenshots

_Add after the workflow completes:_

- [ ] Resource group overview showing all created resources
- [ ] Container App overview with the public URL
- [ ] Successful workflow run on the Actions tab
- [ ] Browser tab showing the running app

## Notes for the grader

- `jcurry9@ewu.edu` has been added as a Contributor on the subscription.
- Container image is passed into `terraform apply` via the `container_image` variable; the workflow tags images with the short commit SHA.
