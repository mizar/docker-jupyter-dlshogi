@echo off
cd %~dp0
if not exist .dl\rclone-v1.57.0-windows-amd64.zip (
curl --create-dirs -RLo .dl\rclone-v1.57.0-windows-amd64.zip https://downloads.rclone.org/v1.57.0/rclone-v1.57.0-windows-amd64.zip
powershell "Push-Location .dl;Expand-Archive rclone-v1.57.0-windows-amd64.zip -Force;Pop-Location;"
)
findstr "\[AobaZeroKifu0000\]" "%APPDATA%\rclone\rclone.conf" >NUL
if "%ERRORLEVEL%"=="1" (
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe config create AobaZeroKifu0000 drive scope=drive.readonly root_folder_id=1dbE5xWGQLsduR00oxEGPpZQJtQr_EQ75
)
findstr "\[AobaZeroKifu4707\]" "%APPDATA%\rclone\rclone.conf" >NUL
if "%ERRORLEVEL%"=="1" (
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe config create AobaZeroKifu4707 drive scope=drive.readonly root_folder_id=1bgBIbSEShGHNUShcx_hbmFkWN8eF5Cfk
)
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe --progress --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s sync AobaZeroKifu0000: workspace/data/aobazero_kifu0000
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe --progress --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s sync AobaZeroKifu4707: workspace/data/aobazero_kifu4707
