<# PSScriptInfo
.VERSION 1.0.0
.GUID e009159d-97e2-492a-a289-42426518dd41
.AUTHOR CloudSmith Consulting LLC
.COMPANYNAME CloudSmith Consulting LLC
.COPYRIGHT (c) 2019 CloudSmith Consulting LLC.  All Rights Reserved.
.TAGS Windows PowerShell Setup Dynamics CRM OneBox
.LICENSEURI https://github.com/cloudsmithconsulting/Dynamics-ARM-Template/blob/master/LICENSE
.PROJECTURI https://github.com/cloudsmithconsulting/Dynamics-ARM-Template
.ICONURI 
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES
#>

<# 
.DESCRIPTION 
 Installs the SDK
#> 

<#
.SYNOPSIS 
    Let's you quickly install the SDK on your computer

.DESCRIPTION
    This script was created to quickly and easily install the SDK on a computer

.EXAMPLE
    .\Install-Sdk -Path ".\Path\To\Install"
    
.Notes
#>
Param
(
	[string] $Path = ".\Tools"
)

$sourceNugetExe = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"
$targetNugetExe = ".\nuget.exe"
Remove-Item $Path -Force -Recurse -ErrorAction Ignore
Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
Set-Alias nuget $targetNugetExe -Scope Global -Verbose

##
##Download Plugin Registration Tool
##
./nuget install Microsoft.CrmSdk.XrmTooling.PluginRegistrationTool -O $Path
$prtDestPath = Join-Path -Path $Path -ChildPath "PluginRegistration"
md $prtDestPath
$prtToolsFolder = Get-ChildItem $Path | Where-Object {$_.Name -match 'Microsoft.CrmSdk.XrmTooling.PluginRegistrationTool.'}
$prtToolsGlob = "$Path\$prtToolsFolder\tools\*.*"
move $prtToolsGlob $prtDestPath
$prtRootFolder = "$Path\$prtToolsFolder"
Remove-Item $prtRootFolder -Force -Recurse

##
##Download CoreTools
##
./nuget install  Microsoft.CrmSdk.CoreTools -O $Path
$coreDestPath = Join-Path -Path $Path -ChildPath "CoreTools"
md $coreDestPath
$coreToolsFolder = Get-ChildItem $Path | Where-Object {$_.Name -match 'Microsoft.CrmSdk.CoreTools.'}
$coreToolsGlob = "$Path\$coreToolsFolder\content\bin\coretools\*.*"
move $coreToolsGlob .\Tools\CoreTools
$coreToolsRootFolder = "$Path\$coreToolsFolder"
Remove-Item $coreToolsRootFolder -Force -Recurse

##
##Download Configuration Migration
##
./nuget install  Microsoft.CrmSdk.XrmTooling.ConfigurationMigration.Wpf -O $Path
$ChildPath = Join-Path -Path $Path -ChildPath "ConfigurationMigration"
md $ChildPath
$configMigFolder = Get-ChildItem $Path | Where-Object {$_.Name -match 'Microsoft.CrmSdk.XrmTooling.ConfigurationMigration.Wpf.'}
move .\Tools\$configMigFolder\tools\*.* .\Tools\ConfigurationMigration
Remove-Item .\Tools\$configMigFolder -Force -Recurse

##
##Download Package Deployer 
##
./nuget install  Microsoft.CrmSdk.XrmTooling.PackageDeployment.WPF -O $Path
$ChildPath = Join-Path -Path $Path -ChildPath "PackageDeployment"
md $ChildPath
md .\Tools\PackageDeployment
$pdFolder = Get-ChildItem $Path | Where-Object {$_.Name -match 'Microsoft.CrmSdk.XrmTooling.PackageDeployment.Wpf.'}
move .\Tools\$pdFolder\tools\*.* .\Tools\PackageDeployment
Remove-Item .\Tools\$pdFolder -Force -Recurse

##
##Download Package Deployer PowerShell module
##
./nuget install Microsoft.CrmSdk.XrmTooling.PackageDeployment.PowerShell -O $Path
$pdPoshFolder = Get-ChildItem $Path | Where-Object {$_.Name -match 'Microsoft.CrmSdk.XrmTooling.PackageDeployment.PowerShell.'}
move .\Tools\$pdPoshFolder\tools\*.* .\Tools\PackageDeployment.PowerShell
Remove-Item .\Tools\$pdPoshFolder -Force -Recurse

##
##Remove NuGet.exe
##
Remove-Item nuget.exe 