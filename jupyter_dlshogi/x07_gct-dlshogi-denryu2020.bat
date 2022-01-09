@echo off
cd %~dp0
curl --create-dirs -z workspace/data/denryu2020/gct-dlshogi-denryu2020.zip -RLo workspace/data/denryu2020/gct-dlshogi-denryu2020.zip https://github.com/TadaoYamaoka/DeepLearningShogi/releases/download/denryu2020/gct-dlshogi-denryu2020.zip
powershell Expand-Archive workspace/data/denryu2020/gct-dlshogi-denryu2020.zip workspace/data/denryu2020/ -Force
