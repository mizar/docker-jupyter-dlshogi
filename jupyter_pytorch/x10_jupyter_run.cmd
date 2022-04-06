@echo off
cd %~dp0
docker build . -f jupyter_pytorch.dockerfile -t jupyter_pytorch
docker run --rm -p 18888:8888 -v %CD:\=/%/workspace:/workspace --name pytorch-jupyter --gpus all --ipc=host jupyter_pytorch bash -c "jupyter lab --NotebookApp.password=\"`cat .jupyter_password`\""
