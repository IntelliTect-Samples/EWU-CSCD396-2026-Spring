# EWU-CSCD396-2023-Fall

## Assignment 2 - DRAFT!!!

The purpose of this assignment is to solidify your learning of:

- Build and deploying containers
- Terraform IaC
- Fnctions and Logic Apps
- Messaging and Eventing

## Prerequisites

- Install VSCode Extension 'Azure App Service'

## Instructions

- All cloud infrastructure should be built with Terraform. Terraform State should be maintained in a Storage Account
- All services should be deployed through a GitHub Action workflow

Complete the following Tutorials and do not clean up resources until assignment is graded.

1. Create and deploy a containerized Web App

   {https://learn.microsoft.com/en-us/azure/app-service/quickstart-dotnetcore?tabs=net70&pivots=development-environment-cli}
   Note: Deploy application code using az cli, not the VSCode extension

- Web App Created ❌✅
  (You can use the below steps to publish your app OR use the 'az webapp up' command in the above tutorial)

  - Run command from your terminal 'dotnet publish SampleApp/MyFirstAzureWebApp'. This builds the application and files are genearted in SampleApp/MyFirstAzureWebApp/bin/Debug/net7.0/publish folder
  - Zip the items in your created publish folder
  - Use 'az webapp deploy' command to deploy your zip file to the application

- Url Accessible ❌✅

2. Create and deploy an Auzre Function Bound to Service Bus. The function should write messages received to a storage account

   {https://learn.microsoft.com/en-us/azure/app-service/scenario-secure-app-access-storage?tabs=azure-cli}

- Enabled Managed Identity on Web App ❌✅
- Created Storage Account ❌✅
- Web App Granted Access to Storage Account ❌✅

3. Add a feature to the web app to write a message to the Service Bus from step 2. Ideally this ia a text box for the message and a button to submit the message to the bus. You can use the Azure SDK for .NET to send messages to the bus from your web app.




4. Create a PowerShell script called Assignment2.ps1 on your branch within the Assignment2 folder ❌✅

- Copy the following text into your PowerShell script and fill in your specific values for the variables
```
$SubscriptionId = ""
$ResourceGroup = ""
$WebAppName = ""
$WebAppUrl = ""
$KeyVault = ""
$SecretName = ""
$StorageAccount = ""
```
- You can test if your assignment will pass by running the PS script at Scripts/Assignment2Grading.ps1. Run your Assignment2.ps1 script to set local variables first.

5. Please add jcurry9@ewu.edu as a contributor to your subscription, otherwise grading will not be possible.


## Extra Credit

- Have the web app write the message to an Azure SQL Table in addition to the message bus
- 
