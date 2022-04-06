@echo off
cd %~dp0
docker build . -f jupyter_tensorflow.dockerfile -t jupyter_tensorflow
docker run -it --rm -v %CD:\=/%/workspace:/workspace --gpus all --ipc=host jupyter_tensorflow
