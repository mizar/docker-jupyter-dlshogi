@echo off
cd %~dp0
curl --create-dirs -RLo .dl\DockerDesktopInstaller.exe "https://desktop.docker.com/win/stable/amd64/Docker Desktop Installer.exe"
.dl\DockerDesktopInstaller.exe install --quiet
echo;
echo Docker Desktop for Windows is installed. LOGOFF after 5 seconds to complete the installation.
powershell sleep 5
logoff
