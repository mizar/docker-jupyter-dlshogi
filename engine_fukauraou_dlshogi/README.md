# 将棋AIエンジン ふかうら王,dlshogi (TensorRT版) 構築

## 動作環境

- Windows 10 21H2以降 もしくは Windows 11
- NVIDIA GeForce RTX 2000/3000 シリーズ もしくは 相当品以上の NVIDIA製グラフィック環境
- Windows Subsystem for Linux (WSL) が有効であること
- CUDA on WSL 対応グラフィックドライバがインストール済みであること
- Docker Desktop for Windows がインストール済み
- インターネット接続環境（導入時に必要、できるだけ高速で接続が安定していること）
- ふかうら王/dlshogiコンテナのディスク使用量 : 約7GB ～

## ファイル構成

- エンジンベンチマーク用バッチファイル(エンジン動作環境のビルド/ベンチマーク用)
  - `bench_t1_fukauraou_avx2.bat` : ふかうら王エンジン(AVX2版,スレッド数=1)ベンチマーク用バッチファイル
  - `bench_t1_fukauraou_zen2.bat` : ふかうら王エンジン(ZEN2版,スレッド数=1)ベンチマーク用バッチファイル
  - `bench_t2_fukauraou_avx2.bat` : ふかうら王エンジン(AVX2版,スレッド数=2)ベンチマーク用バッチファイル
  - `bench_t2_fukauraou_zen2.bat` : ふかうら王エンジン(ZEN2版,スレッド数=2)ベンチマーク用バッチファイル
  - `bench_t3_fukauraou_avx2.bat` : ふかうら王エンジン(AVX2版,スレッド数=3)ベンチマーク用バッチファイル
  - `bench_t3_fukauraou_zen2.bat` : ふかうら王エンジン(ZEN2版,スレッド数=3)ベンチマーク用バッチファイル
  - `bench_t4_fukauraou_avx2.bat` : ふかうら王エンジン(AVX2版,スレッド数=4)ベンチマーク用バッチファイル
  - `bench_t4_fukauraou_zen2.bat` : ふかうら王エンジン(ZEN2版,スレッド数=4)ベンチマーク用バッチファイル
- エンジンビルド用バッチファイル(エンジン動作環境のビルド用)
  - `setup_dlshogi_wcsc31.bat` : ふかうら王/dlshogiエンジンビルド・WCSC31版dlshogi with GCTモデルダウンロード用バッチファイル
    cf. [2021-05-05 dlshogi with GCT（WCSC31バージョン）のWindows版ビルド済みファイル公開](https://tadaoyamaoka.hatenablog.com/entry/2021/05/05/121233)
  - `fukauraou_dlshogi_build.bat` : ふかうら王/dlshogiエンジンビルド用バッチファイル
  - `fukauraou_dlshogi_rebuild.bat` : ふかうら王/dlshogiエンジン再ビルド用バッチファイル
- エンジン起動用バッチファイル(ShogiGUI等への登録用)
  - `engine_dlshogi.bat` : dlshogiエンジン(AVX2版)起動用バッチファイル
  - `engine_fukauraou_avx2.bat` : ふかうら王エンジン(AVX2版)起動用バッチファイル
  - `engine_fukauraou_zen2.bat` : ふかうら王エンジン(ZEN2版)起動用バッチファイル
- その他
  - `engine_options.txt` : ふかうら王用デフォルトオプション変更用ファイル
  - `README.md` : このファイル

## 注釈

- ShogiGUIでは、エンジンの追加時に指定できるファイルの種類が「開く」ダイアログのデフォルトで「`実行ファイル (*.exe)`」となっています。「`Windows バッチ ファイル (*.bat)`」をエンジンとしてファイルを選択して登録するためには、これを「`すべてのファイル (*.*)`」に変更する必要があります。
