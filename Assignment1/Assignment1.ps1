# Assignment 1 - Azure Resource Listing Script
# CSCD 396 - DevOps

# Your Azure Subscription ID
$subscription_id = "d7dc33ae-d588-44a6-bda7-3e08dbd66d6f"

# Set the active subscription
az account set --subscription $subscription_id

# List all resources in the subscription
Write-Host "=== All Resources in Subscription ==="
az resource list --subscription $subscription_id --output table

Write-Host ""
Write-Host "=== Resource Groups ==="
az group list --subscription $subscription_id --output table

Write-Host ""
Write-Host "=== Storage Accounts ==="
az storage account list --subscription $subscription_id --output table
