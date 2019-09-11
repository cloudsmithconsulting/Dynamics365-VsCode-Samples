New-Item -Path C:\Deploy\XrmToolbox -ItemType Directory
$source = "https://github.com/MscrmTools/XrmToolBox/releases/download/v1.2019.7.34/XrmToolbox.zip"
$dest = "C:\Deploy\XrmToolbox\XrmToolbox.zip"
Invoke-WebRequest $source -OutFile $dest -TimeoutSec 180

Expand-Archive -LiteralPath $dest -DestinationPath "C:\Deploy\Tools\XrmToolbox"