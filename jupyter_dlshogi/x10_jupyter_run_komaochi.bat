@echo off
cd %~dp0
docker build . -f jupyter_dlshogi_komaochi.dockerfile -t jupyter_dlshogi:komaochi
docker run --rm -p 8889:8888 -v %CD:\=/%/workspace:/workspace --name jupyter_dlshogi_komaochi --gpus all --ipc=host jupyter_dlshogi:komaochi bash -c "jupyter lab --NotebookApp.password=\"`cat .jupyter_password`\""
