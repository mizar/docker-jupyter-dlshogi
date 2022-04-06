@echo off
cd %~dp0
docker build . -f fukauraou_dlshogi.dockerfile -t fukauraou --no-cache
