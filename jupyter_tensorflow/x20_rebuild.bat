@echo off
cd %~dp0
docker build . -f jupyter_tensorflow.dockerfile -t jupyter_tensorflow --no-cache
