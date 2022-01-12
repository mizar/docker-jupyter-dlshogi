@echo off
cd %~dp0
call suisho5_yaneuraou_build.bat
for /f "usebackq" %%a in (`powershell -Command ^(Get-CimInstance Win32_Processor^).NumberOfCores`) do set NUMBER_OF_CORES=%%a
docker run -i --rm --ipc=host suisho5 Suisho5-YaneuraOu-tournament-avx2 bench 4096 %NUMBER_OF_CORES% , quit
pause
