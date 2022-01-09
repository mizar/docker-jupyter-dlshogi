@echo off
docker run -i --rm --gpus all -v %CD%:/workspace --ipc=host fukauraou dlshogi_usi %1 %2 %3 %4 %5 %6 %7 %8 %9
