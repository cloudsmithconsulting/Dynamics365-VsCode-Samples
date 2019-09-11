# Setup IE's Trusted Sites zone to automatically login with current windows user creds (Intranet zone + Trusted sites zone)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" -Name "1A00" -Value "0"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" -Name "1A00" -Value "0"
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" -Name "1A00" -Value "0"
Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" -Name "1A00" -Value "0"

# Disable protected mode for trusted sites + intranet
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" -Name "2500" -Value "3"
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" -Name "2500" -Value "3"

# Add site to trusted sites zone.
Set-Location "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains"

# Create a new folder with the website name
New-Item crmserver/ -Force # website part without http/s
Set-Location crmserver/
New-ItemProperty . -Name https -Value 2 -Type DWORD -Force
New-ItemProperty . -Name http -Value 2 -Type DWORD -Force