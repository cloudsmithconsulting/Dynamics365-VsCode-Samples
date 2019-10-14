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
.EXTERNALMODULEDEPENDENCIES Microsoft.Xrm.Data.PowerShell
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES 1.0 Sample for PowerShell driven Dynamics CRM development loop.
#>

<# 
.DESCRIPTION 
 Retrieves a Dynamics 365 CE solution from a server and unpacks it into a specified path.
#> 

<#
.SYNOPSIS 
    Automates solution export, download and unpack tasks.

.DESCRIPTION
    This script is to be used after changes have been made to a solution 
	in Dynamics 365 CE.  The output file and folder structure are suitable for 
	version control.

.EXAMPLE
    .\Get-XrmSolution `
		-ServerUrl "http://servername" `
		-OrgName = "test" `
		-SolutionName "Test-Solution" `
		-Path "C:\dev\dynamics-solution" `
		-ToolsPath "C:\deploy\tools\coretools" `
		# Optional line below.  If you do not supply credentials, you will be prompted for them.
		-Credential = New-Object System.Management.Automation.PSCredential (“username”, ( ConvertTo-SecureString “password” -AsPlainText -Force ) ) `
    
.Notes
#>
##Download Microsoft.Xrm.Data.PowerShell and install it.
Param
(
	[string] 
	[parameter(Mandatory = $true, ParameterSetName = "Deployment", HelpMessage = "Dynamics 365 CE server URL (no org name)")]
	[ValidatePattern('http(s)?://[\w-]+(/[\w- ./?%&=]*)?')]
	$ServerUrl,

	[string] 
	[parameter(Mandatory = $true, ParameterSetName = "Deployment", HelpMessage = "Dynamics 365 CE organization name")]
	$OrgName,

	[string]
	[parameter(Mandatory = $true, ParameterSetName = "Deployment", HelpMessage = "Name of the solution to export")]
	$SolutionName,

	[string]
	[parameter(Mandatory = $true, ParameterSetName = "Deployment", HelpMessage = "The path where solution files will be unpacked")]
	[ValidateScript({Test-Path $_})]
	$Path,

    [System.Management.Automation.PSCredential]
	[Parameter(Mandatory=$false, ParameterSetName = "Deployment", HelpMessage = "Credentials of user for authentication.")]
    [ValidateNotNull()]
    [System.Management.Automation.Credential()]
	$Credential = $Null,

	[string] 
	[parameter(Mandatory = $true, ParameterSetName = "Tools", HelpMessage = "Path to SolutionPackager.exe")]
	[ValidateScript({Test-Path $_})]
	$ToolsPath = "C:\Deploy\Tools\CoreTools"
)

# locals
[string] $ModuleName = "Microsoft.Xrm.Data.Powershell";
[string] $ModuleVersion = "2.7.2";

# ensure Microsoft.Xrm.Data.PowerShell dependency is installed and imported.
if (!(Get-Module -ListAvailable -Name $ModuleName )) 
{
    Install-Module -Name $ModuleName -MinimumVersion $ModuleVersion -Force
}

Import-Module $ModuleName

# connect to on-prem
$Conn;

if ($Credential -ne $null)
{
	$Conn = Connect-CrmOnPremDiscovery -Credential $Credential -ServerUrl $ServerUrl -OrganizationName $OrgName
}
else
{
	$Conn = Connect-CrmOnPremDiscovery -ServerUrl $ServerUrl -OrganizationName $OrgName
}

$Folder = (Join-Path -Path $env:TEMP -ChildPath $SolutionName)

If (!(Test-Path -Path $Folder))
{
    New-Item -Path $Folder -ItemType Directory | Out-Null
}

Write-Host "Running export job on: $SolutionName";

Export-CrmSolution -conn $Conn -SolutionName $SolutionName -SolutionFilePath $Folder -SolutionZipFileName "$SolutionName.zip"

$SolutionPath = (Join-Path $Path -ChildPath $SolutionName);

If (!(Test-Path -Path $SolutionPath))
{
    New-Item -Path $SolutionPath -ItemType Directory | Out-Null
}

Write-Host "Unpacking solution $SolutionName";

Start-Process -FilePath (Join-Path $ToolsPath -ChildPath "SolutionPackager.exe") `
	-ArgumentList "/action:extract /folder:$SolutionPath /zipfile:$Folder\$SolutionName.zip" `
	-Wait

 Remove-Item $Folder -Force -Recurse