@echo off
cd %~dp0
docker build . -f jupyter_dlshogi.dockerfile -t jupyter_dlshogi
docker run --rm -p 8888:8888 -v %CD:\=/%/workspace:/workspace --name jupyter_dlshogi --gpus all --ipc=host jupyter_dlshogi bash -c "jupyter lab --NotebookApp.password=\"`cat .jupyter_password`\""
