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
##Download Microsoft.Xrm.Data.PowerShell and install it.
Param
(
[string] $solutionName = "CloudSmithSample",
[string] $toolsPath = "C:\Deploy\Tools\CoreTools",
[string] $moduleName = "Microsoft.Xrm.Data.Powershell",
[string] $moduleVersion = "2.7.2",
[switch] $managed
)

if (!(Get-Module -ListAvailable -Name $moduleName )) 
{
    Install-Module -Name $moduleName -MinimumVersion $moduleVersion -Force
}

Import-Module $moduleName

$conn = Connect-CrmOnPremDiscovery -ServerUrl "http://crmserver/" -OrganizationName "test"
$folder = (Join-Path -Path $env:TEMP -ChildPath $solutionName)

If (!(Test-Path -Path $folder))
{
    New-Item -Path $folder -ItemType Directory | Out-Null
}

$argument = "/action:pack /folder:C:\Dev\dynamics-sample\$solutionName /zipfile:$folder\$solutionName.zip" 
Write-Host $argument
if ($managed -eq $true)
{
	$argument = $argument + " /packagetype:managed"
}

Start-Process -FilePath (Join-Path $toolsPath -ChildPath "SolutionPackager.exe") `
 -ArgumentList $argument `
 -Wait
Import-CrmSolution -conn $conn -SolutionFilePath "$folder\$solutionName.zip"

Remove-Item $folder -Force -Recurse