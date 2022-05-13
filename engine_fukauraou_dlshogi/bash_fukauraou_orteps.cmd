@echo off
cd %~dp0
docker run -it --rm -v %CD%:/workspace --ipc=host fukauraou:orteps
