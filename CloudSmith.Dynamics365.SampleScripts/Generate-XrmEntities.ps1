# Run this script *AFTER* the CRM SDK has been deployed.
$toolsPath = "C:\Deploy\Tools\CoreTools"

If (!(Test-Path -Path "C:\Dev\dynamics-sample"))
{
    New-Item -Path "C:\Dev\dynamics-sample" -ItemType Directory | Out-Null
}

If (!(Test-Path -Path "C:\Dev\dynamics-sample\CloudSmith.Dynamics365.SampleTests"))
{
    New-Item -Path "C:\Dev\dynamics-sample\CloudSmith.Dynamics365.SampleTests" -ItemType Directory | Out-Null
}

Start-Process -FilePath (Join-Path $toolsPath -ChildPath "CrmSvcUtil.exe") `
 -ArgumentList '/url:http://crmserver/test/XRMServices/2011/Organization.svc /username:missioncommand /password:$mokingTir33 /domain:CONTOSO /namespace:CloudSmith.Dynamics365.SampleTests /out:C:\Dev\dynamics-sample\CloudSmith.Dynamics365.SampleTests\XrmEntities.cs' `
 -Wait