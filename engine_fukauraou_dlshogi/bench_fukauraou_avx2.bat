@echo off
cd %~dp0
call setup_dlshogi_wcsc31.bat
docker run -i --rm --gpus all -v %CD%:/workspace --ipc=host fukauraou FukauraOu-avx2 bench , quit
pause
