# Assignment 1 - Powershell Script for Azure Subscription
$subscription_id = "207d6c46-9d83-44fc-b7d5-6e2cfcf4d001"

Set-AzContext -SubscriptionId $subscription_id
Get-AzResource