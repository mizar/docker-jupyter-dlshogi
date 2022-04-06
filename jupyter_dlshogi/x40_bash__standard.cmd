@echo off
cd %~dp0
docker build . -f jupyter_dlshogi.dockerfile -t jupyter_dlshogi
docker run -it --rm -v %CD:\=/%/workspace:/workspace --gpus all --ipc=host jupyter_dlshogi
