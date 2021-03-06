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

- エンジンベンチマーク用コマンドスクリプト(エンジン動作環境のビルド/ベンチマーク用)
  - `bench_t1_fukauraou_cpu.cmd` : ふかうら王エンジン(CPU,スレッド数=1)ベンチマーク用コマンドスクリプト
  - `bench_t1_fukauraou_avx2.cmd` : ふかうら王エンジン(AVX2版,スレッド数=1)ベンチマーク用コマンドスクリプト
  - `bench_t1_fukauraou_zen2.cmd` : ふかうら王エンジン(ZEN2版,スレッド数=1)ベンチマーク用コマンドスクリプト
  - `bench_t2_fukauraou_cpu.cmd` : ふかうら王エンジン(CPU版,スレッド数=2)ベンチマーク用コマンドスクリプト
  - `bench_t2_fukauraou_avx2.cmd` : ふかうら王エンジン(AVX2版,スレッド数=2)ベンチマーク用コマンドスクリプト
  - `bench_t2_fukauraou_zen2.cmd` : ふかうら王エンジン(ZEN2版,スレッド数=2)ベンチマーク用コマンドスクリプト
  - `bench_t3_fukauraou_avx2.cmd` : ふかうら王エンジン(AVX2版,スレッド数=3)ベンチマーク用コマンドスクリプト
  - `bench_t3_fukauraou_zen2.cmd` : ふかうら王エンジン(ZEN2版,スレッド数=3)ベンチマーク用コマンドスクリプト
  - `bench_t4_fukauraou_avx2.cmd` : ふかうら王エンジン(AVX2版,スレッド数=4)ベンチマーク用コマンドスクリプト
  - `bench_t4_fukauraou_zen2.cmd` : ふかうら王エンジン(ZEN2版,スレッド数=4)ベンチマーク用コマンドスクリプト
- エンジンビルド用コマンドスクリプト(エンジン動作環境のビルド用)
  - `setup_dlshogi_wcsc31.cmd` : ふかうら王/dlshogiエンジンビルド・WCSC31版dlshogi with GCTモデルダウンロード用コマンドスクリプト
    cf. [2021-05-05 dlshogi with GCT（WCSC31バージョン）のWindows版ビルド済みファイル公開](https://tadaoyamaoka.hatenablog.com/entry/2021/05/05/121233)
  - `fukauraou_dlshogi_build.cmd` : ふかうら王/dlshogiエンジンビルド用コマンドスクリプト
  - `fukauraou_dlshogi_rebuild.cmd` : ふかうら王/dlshogiエンジン再ビルド用コマンドスクリプト
- エンジン起動用バッチファイル(ShogiGUI等への登録用)
  - `engine_dlshogi.cmd` : dlshogiエンジン(AVX2版)起動用バッチファイル
  - `engine_fukauraou_cpu.cmd` : ふかうら王エンジン(CPU版)起動用バッチファイル
  - `engine_fukauraou_avx2.cmd` : ふかうら王エンジン(AVX2版)起動用バッチファイル
  - `engine_fukauraou_zen2.cmd` : ふかうら王エンジン(ZEN2版)起動用バッチファイル
- その他
  - `engine_options.txt` : ふかうら王用デフォルトオプション変更用ファイル
  - `README.md` : このファイル

## 注釈

- [ShogiGUI](http://shogigui.siganus.com/)では、エンジンの追加時に指定できるファイルの種類が「開く」ダイアログのデフォルトで「`実行ファイル (*.exe)`」となっています。「`Windows コマンド スクリプト (*.cmd)`」をエンジンとしてファイルを選択して登録するためには、これを「`すべてのファイル (*.*)`」に変更する必要があります。
- [将棋所](http://shogidokoro.starfree.jp/)では、エンジンの追加時に「`Windows コマンド スクリプト (*.cmd)`」をエンジンとしてファイルを選択して登録するためには、5.0.1以降のバージョンが必要です。（それ以前のバージョンでもファイルを選択できないだけで、ファイル名入力欄に直接ファイル名を入力すれば登録することはできるようです。）
