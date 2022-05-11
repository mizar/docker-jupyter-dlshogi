@echo off
cd %~dp0
call setup_dlshogi_wcsc31.cmd
docker run -i --rm -v %CD%:/workspace --ipc=host fukauraou FukauraOu-cpu bench 1 2 , quit
pause
