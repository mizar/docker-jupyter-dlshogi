@echo off
cd %~dp0
docker run -i --rm -v %CD%:/workspace --ipc=host suisho5 Suisho5-YaneuraOu-tournament-sse42 %1 %2 %3 %4 %5 %6 %7 %8 %9
