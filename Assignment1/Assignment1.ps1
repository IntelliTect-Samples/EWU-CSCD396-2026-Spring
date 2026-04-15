# Assignment 1 - Powershell Script for Azure Subscription
$subscription_id = "207d6c46-9d83-44fc-b7d5-6e2cfcf4d001"
Set-AzContext -SubscriptionId $subscription_id

$location = "eastus"

# Check whether to create resource group
$resourceGroupName = "extracreditrg"
if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $resourceGroupName -Location $location
}

# Same for storage account
$storageAccountName = "extracreditsawiilke"
if (-not (Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -ErrorAction SilentlyContinue)) {
    New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -Location $location -SkuName Standard_LRS -Kind StorageV2
}

# Listing resources
Write-Host "Resources:"
Get-AzResource -ResourceGroupName $resourceGroupName

# Delete storage account
Remove-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -Force

# Listing resources again
Write-Host "Resources after deletion:"
Get-AzResource -ResourceGroupName $resourceGroupName