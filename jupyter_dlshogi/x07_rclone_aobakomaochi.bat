@echo off
cd %~dp0
if not exist .dl\rclone-v1.57.0-windows-amd64.zip (
curl --create-dirs -RLo .dl\rclone-v1.57.0-windows-amd64.zip https://downloads.rclone.org/v1.57.0/rclone-v1.57.0-windows-amd64.zip
powershell "Push-Location .dl;Expand-Archive rclone-v1.57.0-windows-amd64.zip -Force;Pop-Location;"
)
findstr "\[AobaKomaochiKifu0000\]" "%APPDATA%\rclone\rclone.conf" >NUL
if "%ERRORLEVEL%"=="1" (
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe config create AobaKomaochiKifu0000 drive scope=drive.readonly root_folder_id=1F2LixsQQfyTx1RKhv-BgAlUGQJ4qUAxS
)
findstr "\[AobaKomaochiKifu0060\]" "%APPDATA%\rclone\rclone.conf" >NUL
if "%ERRORLEVEL%"=="1" (
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe config create AobaKomaochiKifu0060 drive scope=drive.readonly root_folder_id=1r4YikBUMIn6_Mxtqz2lE-UF0tQn_OkZb
)
findstr "\[AobaKomaochiKifu0290\]" "%APPDATA%\rclone\rclone.conf" >NUL
if "%ERRORLEVEL%"=="1" (
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe config create AobaKomaochiKifu0290 drive scope=drive.readonly root_folder_id=1Ml9lWOBNsCfggsppRLLqLrB1DWByP6yP
)
findstr "\[AobaKomaochiKifu0550\]" "%APPDATA%\rclone\rclone.conf" >NUL
if "%ERRORLEVEL%"=="1" (
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe config create AobaKomaochiKifu0550 drive scope=drive.readonly root_folder_id=1HRf1WgvkbRK0mFputz6PpJM1ECZpSFbn
)
findstr "\[AobaKomaochiKifu0810\]" "%APPDATA%\rclone\rclone.conf" >NUL
if "%ERRORLEVEL%"=="1" (
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe config create AobaKomaochiKifu0810 drive scope=drive.readonly root_folder_id=16daOl__9CK3hXMWEVVDo_ziYXT3TRt71
)
findstr "\[AobaKomaochiKifu1080\]" "%APPDATA%\rclone\rclone.conf" >NUL
if "%ERRORLEVEL%"=="1" (
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe config create AobaKomaochiKifu1080 drive scope=drive.readonly root_folder_id=1eU1S_b9DZgyceTgdMwGS4RPmNeBY_rKV
)
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe --progress --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s sync AobaKomaochiKifu0000: workspace/data/aobakomaochi_kifu0000
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe --progress --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s sync AobaKomaochiKifu0060: workspace/data/aobakomaochi_kifu0060
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe --progress --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s sync AobaKomaochiKifu0290: workspace/data/aobakomaochi_kifu0290
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe --progress --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s sync AobaKomaochiKifu0550: workspace/data/aobakomaochi_kifu0550
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe --progress --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s sync AobaKomaochiKifu0810: workspace/data/aobakomaochi_kifu0810
.dl\rclone-v1.57.0-windows-amd64\rclone-v1.57.0-windows-amd64\rclone.exe --progress --transfers 30 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 1s sync AobaKomaochiKifu1080: workspace/data/aobakomaochi_kifu1080
