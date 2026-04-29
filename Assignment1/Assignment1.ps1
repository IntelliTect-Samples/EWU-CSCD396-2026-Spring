# Assignment 1: Create and Delete Azure Storage Account

# Define variables
$subscription_id = "98ef8437-66f2-4a03-9d1a-cf7057d27d9c"
$resourceGroupName = "assignment1-rg"
$location = "westus2"
$tempStorageName = ("a1temp" + (Get-Random -Maximum 99999999))

# Connect to Azure account
Write-Host "Connecting to Azure account..."
Set-AzContext -SubscriptionId $subscription_id | Out-Null

# List resources before creating storage account
Write-Host "Listing resources before create:"
Get-AzResource |
Select-Object Name, ResourceGroupName, ResourceType, Location |
Format-Table -AutoSize

# Create a temporary storage account
Write-Host "Creating temp storage account: $tempStorageName"
New-AzStorageAccount `
    -ResourceGroupName $resourceGroupName `
    -Name $tempStorageName `
    -Location $location `
    -SkuName Standard_LRS `
    -Kind StorageV2 | Out-Null

# List resources after creating storage account
Write-Host "Listing resources after create:"
Get-AzResource |
Select-Object Name, ResourceGroupName, ResourceType, Location |
Format-Table -AutoSize

# Delete the temporary storage account
Write-Host "Deleting temp storage account: $tempStorageName"
Remove-AzStorageAccount `
    -ResourceGroupName $resourceGroupName `
    -Name $tempStorageName `
    -Force

# List resources after deleting storage account
Write-Host "Listing resources after delete:"
Get-AzResource |
Select-Object Name, ResourceGroupName, ResourceType, Location |
Format-Table -AutoSize