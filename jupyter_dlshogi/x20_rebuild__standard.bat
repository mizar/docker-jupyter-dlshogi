@echo off
cd %~dp0
docker build . -f jupyter_dlshogi.dockerfile -t jupyter_dlshogi --no-cache
