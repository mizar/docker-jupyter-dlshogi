@echo off
cd %~dp0
docker build . -f fukauraou_orteps.dockerfile -t fukauraou:orteps
