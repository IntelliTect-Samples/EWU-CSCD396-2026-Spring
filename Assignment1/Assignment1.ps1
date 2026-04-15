$subscription_id = "a7cd0bad-bfc7-40ac-acf2-b07966f12423"

Write-Host "=== Subscription Resources (Before) ==="
Get-AzResource | Select-Object Name, ResourceType, ResourceGroupName, Location | Format-Table -AutoSize

# Extra Credit: Create a resource, list it, then delete it
$resourceGroupName = "rg-cscd396"
$storageName = "cscd396ectemp"
$location = "eastus"

Write-Host "`n=== Extra Credit: Creating temporary storage account ==="
New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName -Location $location -SkuName "Standard_LRS"
Write-Host "Storage account '$storageName' created."

Write-Host "`n=== Subscription Resources (After Create) ==="
Get-AzResource | Select-Object Name, ResourceType, ResourceGroupName, Location | Format-Table -AutoSize

Write-Host "`n=== Extra Credit: Deleting temporary storage account ==="
Remove-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageName -Force
Write-Host "Storage account '$storageName' deleted."

Write-Host "`n=== Subscription Resources (After Delete) ==="
Get-AzResource | Select-Object Name, ResourceType, ResourceGroupName, Location | Format-Table -AutoSize
