@echo off
cd %~dp0
call suisho5_yaneuraou_build.bat
docker run -i --rm -v %CD%:/workspace --ipc=host suisho5 Suisho5-YaneuraOu-tournament-avx2 bench , quit
pause
