@powershell.exe "$cim_winos=(Get-CimInstance Win32_OperatingSystem);$cim_winos|Select-Object Caption, OSArchitecture, Version;@([PSCustomObject]@{caption='Windows 10/11 version 21H2 or later?';result=([System.Version]$cim_winos.version -ge '10.0.19044')};[PSCustomObject]@{caption='64bit OS Architecture?';result=($cim_winos.OSArchitecture -like '*64*')};)|Format-Table"
@pause
