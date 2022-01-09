@echo off
cd %~dp0
if not exist .dl\rclone-v1.57.0-windows-amd64.zip (
curl --create-dirs -RLo .dl\rclone-v1.57.0-windows-amd64.zip https://downloads.rclone.org/v1.57.0/rclone-v1.57.0-windows-amd64.zip
powershell "Push-Location .dl;Expand-Archive rclone-v1.57.0-windows-amd64.zip -Force;Pop-Location;"
)
findstr "\[GCTData\]" "%APPDATA%\rclone\rclone.conf" >NUL
if "%ERRORLEVEL%"=="1" (
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe config create GCTData drive scope=drive.readonly root_folder_id=1Lkh4HL0tMx9p3NNbHue9lvh_HOSBGxhv
)
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe --progress --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s sync GCTData: workspace/data/gct
