@echo off
cd %~dp0
curl --create-dirs -RLo .dl\cuda_11.5.1_windows_network.exe https://developer.download.nvidia.com/compute/cuda/11.5.1/network_installers/cuda_11.5.1_windows_network.exe
echo;
echo Installing the CUDA dispaly driver...
.dl\cuda_11.5.1_windows_network.exe -s Display.Driver
echo;
echo Completed installation of CUDA display driver.
powershell sleep 5
