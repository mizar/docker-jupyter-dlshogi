@echo off
cd %~dp0
curl --create-dirs -RLo .dl\dlshogi_with_gct_wcsc31.zip https://github.com/TadaoYamaoka/DeepLearningShogi/releases/download/wcwc31/dlshogi_with_gct_wcsc31.zip
powershell "Push-Location .dl;Expand-Archive dlshogi_with_gct_wcsc31.zip -Force;Pop-Location;"
copy .dl\dlshogi_with_gct_wcsc31\model-0000225kai.onnx model.onnx
copy .dl\dlshogi_with_gct_wcsc31\book_model-0000223_225kai_4m.bin book.bin
call fukauraou_dlshogi_build.bat
call engine_fukauraou_avx2.bat "isready , quit"
