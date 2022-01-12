@echo off
cd %~dp0
call setup_dlshogi_wcsc31.bat
docker run -i --rm --gpus all -v %CD%:/workspace --ipc=host fukauraou FukauraOu-zen2 bench 1 4 , quit
pause
