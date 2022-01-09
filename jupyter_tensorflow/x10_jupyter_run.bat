@echo off
cd %~dp0
docker build . -f jupyter_tensorflow.dockerfile -t jupyter_tensorflow
docker run --rm -p 18889:8888 -v %CD:\=/%/workspace:/workspace --name tensorflow-jupyter --gpus all --ipc=host jupyter_tensorflow bash -c "jupyter lab --NotebookApp.password=\"`cat .jupyter_password`\""
