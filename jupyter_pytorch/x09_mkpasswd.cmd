@echo off
cd %~dp0
docker run --rm -it -v %CD:\=/%/workspace:/workspace nvcr.io/nvidia/pytorch:21.12-py3 python -c "from notebook.auth import passwd;f=open('.jupyter_password','w');f.write(passwd());f.close();"
