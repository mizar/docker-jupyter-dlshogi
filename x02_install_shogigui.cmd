@echo off
powershell -command "$file=\"$(((Invoke-WebRequest http://shogigui.siganus.com/download.html -UseBasicParsing).Links.href^|ForEach-Object{$_ -split '/'}^|Where-Object{$_ -like 'ShogiGUIv*.exe'})[0])\";& curl.exe --create-dirs -RLo \".dl/$file\" \"http://shogigui.siganus.com/shogigui/$file\";& \".dl/$file\" /silent"
