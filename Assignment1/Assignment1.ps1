# Assignment 1 - Powershell Script for Azure Subscription
$subscription_id = "207d6c46-9d83-44fc-b7d5-6e2cfcf4d001"
Set-AzContext -SubscriptionId $subscription_id

$resourceGroupName = "extracreditrgwiilke"
$location = "centralus"

# Create resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Listing resources
Write-Host "Resource groups:"
Get-AzResourceGroup

# Delete resource group
Remove-AzResourceGroup -Name $resourceGroupName -Force

# Listing resources again
Write-Host "Resource groups after deletion:"
Get-AzResourceGroup