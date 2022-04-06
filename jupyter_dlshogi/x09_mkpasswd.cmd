@echo off
cd %~dp0
docker build . -f jupyter_dlshogi.dockerfile -t jupyter_dlshogi
docker run --rm -it -v %CD:\=/%/workspace:/workspace jupyter_dlshogi python -c "from notebook.auth import passwd;f=open('.jupyter_password','w');f.write(passwd());f.close();"
