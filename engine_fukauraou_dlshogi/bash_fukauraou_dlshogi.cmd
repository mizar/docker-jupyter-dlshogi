@echo off
cd %~dp0
docker run -it --rm --gpus all -v %CD%:/workspace --ipc=host fukauraou
