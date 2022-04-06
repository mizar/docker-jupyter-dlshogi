@echo off
cd %~dp0
docker build . -f jupyter_pytorch.dockerfile -t jupyter_pytorch --no-cache
