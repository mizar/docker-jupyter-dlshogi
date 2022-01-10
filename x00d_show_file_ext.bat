@echo off
cd %~dp0
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f
powershell -Command "Stop-Process -Name explorer -Force"
explorer %CD%
