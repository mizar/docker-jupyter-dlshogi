@echo off
cd %~dp0
docker build . -f jupyter_dlshogi_komaochi.dockerfile -t jupyter_dlshogi:komaochi --no-cache
