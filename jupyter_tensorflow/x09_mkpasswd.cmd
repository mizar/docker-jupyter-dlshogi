@echo off
cd %~dp0
docker build . -f jupyter_tensorflow.dockerfile -t jupyter_tensorflow
docker run --rm -it -v %CD:\=/%/workspace:/workspace jupyter_tensorflow python -c "from notebook.auth import passwd;f=open('.jupyter_password','w');f.write(passwd());f.close();"
