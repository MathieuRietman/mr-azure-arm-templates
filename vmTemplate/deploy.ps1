<#
	.SYNOPSIS
        1. deploy script with parameters used as sample

	.DESCRIPTION

	.EXAMPLE
	   .\deploy.ps1 -application "test" -vmIndexnumber "001" -environment "tst" -costcenter "me" -location "westeurope" -existingVnetName  "vnet-wvd-t-weu" -existingSubnetName "pool1" -virtualNetworkResourceGroupName "rg-wvd-t-network-weu"
	   
	.LINK

	.Notes
		NAME:      deploy.ps1
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  11-06-2021
		KEYWORDS:  Template VM UIDefinition
#>

[cmdletbinding()] 
Param (
    [Parameter(Mandatory=$false)]
    [string]$useParameterFile = "false", 

    [Parameter(Mandatory=$true)]
    [string]$application, 
    
    [Parameter(Mandatory=$false)]
    [string]$vmIndexNumber, 

    [Parameter(Mandatory=$true)]
    [string]$environment, 

    [Parameter(Mandatory=$false)]
    [string]$costcenter, 

    [Parameter(Mandatory=$false)]
    [string]$windowsOSVersion, 

    [Parameter(Mandatory=$false)]
    [string]$adminUsername, 

    [Parameter(Mandatory=$false)]
    [securestring]$adminPassword, 
    # better to have them point to keyvault in your template 
    # https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/template-tutorial-use-key-vault#edit-the-parameters-file

    [Parameter(Mandatory=$false)]
    [string]$vmSize, 

    [Parameter(Mandatory=$false)]
    [string]$location="WestEurope", 
    
    [Parameter(Mandatory=$false)]
    [string]$existingVnetName, 

    [Parameter(Mandatory=$false)]
    [string]$existingSubnetName, 

    [Parameter(Mandatory=$false)]
    [string]$virtualNetworkResourceGroupName

)
# considder also subscriptionId as parameter and change  subscriptionId into the script

$Root = $PSScriptRoot + "/"


$templatefile = "$($Root)./template.json"
$parameterfile = "$($Root)./parameter.json"

[hashtable]$parameters = @{ }

if ($application) {   $parameters["application"] = $application }
if ($vmIndexNumber) {   $parameters["vmIndexNumber"] = $vmIndexNumber }
if ($environment) {   $parameters["environment"] = $environment }
if ($costcenter) {   $parameters["costcenter"] = $costcenter }
if ($windowsOSVersion) {   $parameters["windowsOSVersion"] = $windowsOSVersion }
if ($adminUsername) {   $parameters["adminUsername"] = $adminUsername }
if ($adminPassword) {   $parameters["adminPassword"] = $adminPassword }
if ($vmSize) {   $parameters["vmSized"] = $vmSize }
if ($location) {   $parameters["location"] = $location }
if ($existingVnetName) {   $parameters["existingVnetName"] = $existingVnetName}
if ($existingSubnetName) {   $parameters["existingSubnetName"] = $existingSubnetName}
if ($virtualNetworkResourceGroupName) {   $parameters["virtualNetworkResourceGroupName"] = $virtualNetworkResourceGroupName}

if ( [string]::IsNullOrEmpty($costcenter)) { $coscenter = "dummy" }

$resourceGroup = "rg-$($application)-$($environment)"

$Tags = @{application = $application; environment = $environment; costcenter = $costcenter }

Get-AzResourceGroup -Name $resourceGroup -ev notPresent -ea 0 
if ($notPresent) { 

    New-AzResourceGroup -Name $resourceGroup -Location $location -Tags $Tags 
}
else { write-Host "Resource Group already exists" } 

$deploymentname = "$($application)$($environment)$($vmIndexNumber)"
if ($useParameterFile -eq "true"){
    $deploy = New-AzResourceGroupDeployment -Name $deploymentname -TemplateFile $templatefile  -TemplateParameterFile $parameterfile -TemplateParameterObject $parameters -ResourceGroupName $Resourcegroup -Verbose
}
else {
    $deploy = New-AzResourceGroupDeployment -Name $deploymentname -TemplateFile $templatefile  -TemplateParameterObject $parameters -ResourceGroupName $Resourcegroup -Verbose    
}


