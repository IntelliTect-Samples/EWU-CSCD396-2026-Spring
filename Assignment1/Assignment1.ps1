# Assignment1.ps1

$subscription_id = "f884461c-434c-4223-84b3-bc90b2906100"

Set-AzContext -SubscriptionId $subscription_id

Write-Host "Listing resources in subscription: $subscription_id"
Get-AzResource | Select-Object Name, ResourceGroupName, ResourceType, Location

<#
Application (client) ID
399c2d72-4dbb-4b79-842c-ac5b6bc9bb94
Object ID
43d22a25-836a-4ac0-b356-9a6a12239507
Directory (tenant) ID
cbb8585a-58be-4c67-a9e8-aa46ea967bb1
#>