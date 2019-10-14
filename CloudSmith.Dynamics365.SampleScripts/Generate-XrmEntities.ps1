<# PSScriptInfo
.VERSION 1.0.0
.GUID e009159d-97e2-492a-a289-42426518dd41
.AUTHOR CloudSmith Consulting LLC
.COMPANYNAME CloudSmith Consulting LLC
.COPYRIGHT (c) 2019 CloudSmith Consulting LLC.  All Rights Reserved.
.TAGS Windows PowerShell Development Dev Dynamics CRM OnPremises DevOps
.LICENSEURI https://github.com/cloudsmithconsulting/Dynamics365-VsCode-Samples/blob/master/LICENSE
.PROJECTURI https://github.com/cloudsmithconsulting/Dynamics365-VsCode-Samples
.ICONURI 
.EXTERNALMODULEDEPENDENCIES Microsoft.CrmSdk.CoreAssemblies
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES 1.0 Sample for PowerShell driven Dynamics CRM development loop.
#>

<# 
.DESCRIPTION 
 Generates entities into a folder using CrmSvcUtil.
#> 

<#
.SYNOPSIS 
    Automates generation of strongly typed entities.  

.DESCRIPTION
    This script is to be used after changes have been made to a solution 
	in Dynamics 365 CE.  The output file is the result of running CrmSvcUtil.

.EXAMPLE
    .\Generate-XrmEntities `
		-ConnectionString "AuthType=AD;Url=http://server/org;Username=username;Password=password;Domain=domain" `
		-Path "C:\dev\dynamics-solution\plugin" `
		-OutputFile "XrmEntities.cs"
		-ToolsPath "C:\deploy\tools\coretools" 
		# Optional line below.  
		-Namespace "MyNamespace"
    
.Notes
#>
# Run this script *AFTER* the CRM SDK has been deployed.

Param
(
	[string] 
	[parameter(Mandatory = $true, ParameterSetName = "Deployment", HelpMessage = "Dynamics 365 CE Connection String")]
	$ConnectionString,

	[string]
	[parameter(Mandatory = $true, ParameterSetName = "Generation", HelpMessage = "The path where the generated files will go.")]
	[ValidateScript({Test-Path $_})]
	$Path,

	[string]
	[parameter(Mandatory = $true, ParameterSetName = "Generation", HelpMessage = "The name of the file to output.")]
	$OutputFile = "XrmEntities.cs",

	[string]
	[parameter(Mandatory = $false, ParameterSetName = "Generation", HelpMessage = "The namespace to use for code generation.")]
	$Namespace,

	[string] 
	[parameter(Mandatory = $true, ParameterSetName = "Tools", HelpMessage = "Path to CrmSvcUtil.exe")]
	[ValidateScript({Test-Path $_})]
	$ToolsPath = "C:\Deploy\Tools\CoreTools"
)

If (!(Test-Path -Path $Path))
{
    New-Item -Path $Path -ItemType Directory | Out-Null
}

$FullPath = (Join-Path -Path $Path -ChildPath $OutputFile)

if ($Namespace -ne $null)
{
	$Namespace = "/namespace:$Namespace "
}

Start-Process -FilePath (Join-Path $ToolsPath -ChildPath "CrmSvcUtil.exe") `
	-ArgumentList "/connectionstring:'$ConnectionString' $Namespace/out:$FullPath" `
	-Wait