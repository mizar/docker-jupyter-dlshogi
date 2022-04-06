@echo off
cd %~dp0
docker build . -f suisho5_yaneuraou.dockerfile -t suisho5
