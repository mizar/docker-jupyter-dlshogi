@echo off
powershell -command "$file=\"$(((Invoke-WebRequest http://shogigui.siganus.com/download.html).Links.href^|ForEach-Object{$_ -split '/'}^|Where-Object{$_ -like 'ShogiGUIv*.exe'})[0])\";& curl.exe -RLo \".dl/$file\" \"http://shogigui.siganus.com/shogigui/$file\";& \".dl/$file\" /silent"
