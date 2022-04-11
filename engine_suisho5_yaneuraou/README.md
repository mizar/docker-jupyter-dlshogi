# 将棋AIエンジン 水匠5+やねうら王 構築

## ファイル構成

- エンジンベンチマーク用コマンドスクリプト(エンジン動作環境のビルド/ベンチマーク用/スレッド数=物理コア数)
  - `bench_pc_suisho5_yaneuraou_avx2.cmd` : 水匠5+やねうら王エンジン(AVX2/ZEN3版)ベンチマーク用コマンドスクリプト
  - `bench_pc_suisho5_yaneuraou_zen2.cmd` : 水匠5+やねうら王エンジン(ZEN2版)ベンチマーク用コマンドスクリプト
  - `bench_pc_suisho5_yaneuraou_sse42.cmd` : 水匠5+やねうら王エンジン(SSE42版)ベンチマーク用コマンドスクリプト
- エンジンベンチマーク用コマンドスクリプト(エンジン動作環境のビルド/ベンチマーク用/スレッド数=論理プロセッサ数)
  - `bench_lp_suisho5_yaneuraou_avx2.cmd` : 水匠5+やねうら王エンジン(AVX2/ZEN3版)ベンチマーク用コマンドスクリプト
  - `bench_lp_suisho5_yaneuraou_zen2.cmd` : 水匠5+やねうら王エンジン(ZEN2版)ベンチマーク用コマンドスクリプト
  - `bench_lp_suisho5_yaneuraou_sse42.cmd` : 水匠5+やねうら王エンジン(SSE42版)ベンチマーク用コマンドスクリプト
- エンジンビルド用コマンドスクリプト(エンジン動作環境のビルド用)
  - `suisho5_yaneuraou_build.cmd` : 水匠5+やねうら王エンジンビルド用コマンドスクリプト
  - `suisho5_yaneuraou_rebuild.cmd` : 水匠5+やねうら王エンジン再ビルド用コマンドスクリプト
- エンジン起動用バッチファイル(ShogiGUI等への登録用)
  - `engine_suisho5_yaneuraou_avx2.bat` : 水匠5+やねうら王エンジン(AVX2/ZEN3版)起動用バッチファイル
  - `engine_suisho5_yaneuraou_zen2.bat` : 水匠5+やねうら王エンジン(ZEN2版)起動用バッチファイル
  - `engine_suisho5_yaneuraou_sse42.bat` : 水匠5+やねうら王エンジン(SSE42版)起動用バッチファイル
- その他
  - `engine_options.txt` : 水匠5+やねうら王用デフォルトオプション変更用ファイル
  - `README.md` : このファイル

## 注釈

- [ShogiGUI](http://shogigui.siganus.com/)では、エンジンの追加時に指定できるファイルの種類が「開く」ダイアログのデフォルトで「`実行ファイル (*.exe)`」となっています。「`Windows コマンド スクリプト (*.cmd)`」をエンジンとしてファイルを選択して登録するためには、これを「`すべてのファイル (*.*)`」に変更する必要があります。
- [将棋所](http://shogidokoro.starfree.jp/)では、エンジンの追加時に「`Windows コマンド スクリプト (*.cmd)`」をエンジンとしてファイルを選択して登録するためには、5.0.1以降のバージョンが必要です。（それ以前のバージョンでもファイルを選択できないだけで、ファイル名入力欄に直接ファイル名を入力すれば登録することはできるようです。）
