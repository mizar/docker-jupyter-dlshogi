@echo off
cd %~dp0
docker run -i --rm --gpus all -v %CD%:/workspace --ipc=host fukauraou FukauraOu-avx2 %1 %2 %3 %4 %5 %6 %7 %8 %9
