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
 Generates the SDK
#> 

<#
.SYNOPSIS 
    Let's you quickly generate the SDK on your computer

.DESCRIPTION
    This script was created to quickly and easily generate the SDK on a computer

.EXAMPLE
    .\Install-Sdk -Path ".\Path\To\Install"
    
.Notes
#>
# Run this script *AFTER* the CRM SDK has been deployed.

Param
(
	[string] $Path = 'C:\Dev\dynamics-sample'
)

If (!(Test-Path -Path $Path))
{
    New-Item -Path $Path -ItemType Directory | Out-Null
}

$ToolsPath = "C:\Deploy\Tools\CoreTools"

$FullPath = (Join-Path -Path $Path -ChildPath "XrmEntities.cs")

Start-Process -FilePath (Join-Path $ToolsPath -ChildPath "CrmSvcUtil.exe") `
 -ArgumentList "/url:http://crmserver/test/XRMServices/2011/Organization.svc /username:missioncommand /password:`$mokingTir33 /domain:CONTOSO /namespace:CloudSmith.Dynamics365.SampleTests /out:$FullPath" `
 -Wait