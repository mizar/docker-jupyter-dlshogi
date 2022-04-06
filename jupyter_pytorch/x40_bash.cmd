@echo off
cd %~dp0
docker build . -f jupyter_pytorch.dockerfile -t jupyter_pytorch
docker run -it --rm -v %CD:\=/%/workspace:/workspace --gpus all --ipc=host jupyter_pytorch