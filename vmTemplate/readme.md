## VM sample with UIDefinition

VM no public IP in existing vNet with backup, and shutdown schedule
(No monitoring in template)

Use below button to deploy via UIDefinition. Easy select existing networks

| Type | Description | ARM Templates | 
|:-------------------------|:-------------|:-------------|
| Deploy the custom Policies from master branche| Deploys or update custom policies to a selected management group |[![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fmr-azure-arm-templates%2Fmaster%2FvmTemplate%2Ftemplate.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fmr-azure-arm-templates%2Fmaster%2FvmTemplate%2FcreateUIDefinition.json) | 


Alternative deploy via Powershell script.

``` code 
.\deploy.ps1 -application "test" -vmIndexnumber "001" -environment "tst" -costcenter "me" -location "westeurope" -existingVnetName  "vnet-wvd-t-weu" -existingSubnetName "pool1" -virtualNetworkResourceGroupName "rg-wvd-t-network-weu"
```