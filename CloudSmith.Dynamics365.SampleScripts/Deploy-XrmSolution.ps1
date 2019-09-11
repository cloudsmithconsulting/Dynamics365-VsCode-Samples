##Download Microsoft.Xrm.Data.PowerShell and install it.

$solutionName = "CloudSmithSample"
$toolsPath = "C:\Deploy\Tools\CoreTools"
$moduleName = "Microsoft.Xrm.Data.Powershell"
$moduleVersion = "2.7.2"

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

Start-Process -FilePath (Join-Path $toolsPath -ChildPath "SolutionPackager.exe") `
 -ArgumentList "/action:pack /folder:C:\Dev\dynamics-sample\$solutionName /zipfile:$folder\$solutionName.zip" `
 -Wait

Import-CrmSolution -conn $conn -SolutionName $solutionName -SolutionFilePath "$folder\$solutionName.zip"

Remove-Item $folder -Force -Recurse