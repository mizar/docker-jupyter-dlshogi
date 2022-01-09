@echo off
cd %~dp0
docker build . -f jupyter_dlshogi_komaochi.dockerfile -t jupyter_dlshogi:komaochi
docker run -it --rm -v %CD:\=/%/workspace:/workspace --gpus all --ipc=host jupyter_dlshogi:komaochi
