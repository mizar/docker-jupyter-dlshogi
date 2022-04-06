# docker-jupyter-dlshogi
Docker Desktop for Windows + NVIDIA GeForce RTX シリーズの GPU 搭載 PC 向け dlshogi/ふかうら王 JupyterLab 機械学習環境構築サンプル

## Docker Desktop 環境などの事前準備

- [Download ZIP](https://github.com/mizar/docker-jupyter-dlshogi/archive/refs/heads/main.zip) リンクより、ファイル一式をダウンロード
- 以下の手順に従って、順番に Windowsコマンドスクリプト (*.cmd) を実行

### 準備0
- `x00a_remove_zoneid.cmd` : フォルダ内のファイルに対して、「インターネット等、別のコンピュータから取得したファイル」警告用フラグを消去
- `x00b_windows_version.cmd` : Windows 10/Windows 11 の バージョン10.0.19044 (21H2)以降、OSArchitecture が 64ビットであるかの確認
- `x00c_get_device_display.cmd` : ディスプレイデバイス NVIDIA GeForce RTX が PC に存在するか・有効であるかの確認
- `x00d_show_file_ext.cmd` : ファイルエクスプローラにて、ファイルの拡張子を表示する設定をする。エクスプローラは設定有効化のため、プロセスをいったん終了して開き直す。
### 準備1
- `x01_enable_windowsoptionalfeature.cmd` : Windowsの機能「仮想マシン プラットフォーム」「Linux 用 Windows サブシステム」を有効化し、必要であれば自動的に Windows を再起動する
### サインイン
- 「仮想マシン プラットフォーム」「Linux 用 Windows サブシステム」有効化のために
Windows を再起動した場合、 Windows にサインイン
### 準備2
- `x02_install_shogigui.cmd` : ShogiGUI をインストール。インターネット接続が必要。
- `x03_cuda_displaydriver.cmd` : 「NVIDIA CUDA」対応ディスプレイドライバをインストール。インターネット接続が必要。
- `x04_wsl_update_shutdown.cmd` : 「Linux 用 Windows サブシステム」をアップデート。インターネット接続が必要。
- `x05_install_docker_desktop.cmd` : 「Docker Desktop for Windows」をインストール。インターネット接続が必要。インストールプログラム終了後、インストールした Docker Desktop 有効化のため、 自動的に Windows をサインオフする
### サインイン
- Docker Desktop 有効化のため自動的に Windows をサインオフした後、 Windows にサインイン
- Docker Desktop 利用規約・サブスクリプションプランに同意
  > Docker Desktop can be used for free as part of a Docker Personal subscription for: small companies (fewer than 250 employees AND less than $10 million in annual revenue), personal use, education, and non-commercial open source projects.
  > 
  > Docker Desktopは、Docker Personalサブスクリプションの一部として、小規模企業（従業員250人未満、年間売上1000万ドル未満）、個人利用、教育、非商用オープンソースプロジェクト向けに無料で利用することができます。

## 将棋AIエンジンの構築 (ShogiGUI エンジン登録用)

- [`engine_suisho5_yaneuraou/`](engine_suisho5_yaneuraou/) : 水匠5 + やねうら王 エンジンの構築
  - cf. [https://github.com/yaneurao/YaneuraOu](https://github.com/yaneurao/YaneuraOu)
  - cf. [Twitter:たややん＠水匠(将棋AI)](https://twitter.com/tayayan_ts)
- [`engine_fukauraou_dlshogi/`](engine_fukauraou_dlshogi/) : dlshogi(DeepLearningShogi) , ふかうら王(dlshogi互換版やねうら王) (TensorRT版) エンジンの構築 (NVIDIA GeForce RTX シリーズの GPU 搭載 PC 向け)
  - cf. [https://github.com/TadaoYamaoka/DeepLearningShogi](https://github.com/TadaoYamaoka/DeepLearningShogi)
  - cf. [https://github.com/yaneurao/YaneuraOu](https://github.com/yaneurao/YaneuraOu)

## dlshogi + JupyterLab + PyTorch 機械学習環境

- [`jupyter_dlshogi/`](jupyter_dlshogi/) : JupyterLab + PyTorch + dlshogi 機械学習環境サンプル (NVIDIA GeForce RTX シリーズの GPU 搭載 PC 向け)

## JupyterLab + PyTorch/TensorFlow 機械学習環境

dlshogiは不要だが、JupyterLab + NVIDIA GPU での機械学習環境 を使いたい人向けサンプル

- [`jupyter_pytorch/`](jupyter_pytorch/) : JupyterLab + PyTorch 環境サンプル (NVIDIA GeForce RTX シリーズの GPU 搭載 PC 向け)
- [`jupyter_tensorflow/`](jupyter_tensorflow/) : JupyterLab + TensorFlow 環境サンプル (NVIDIA GeForce RTX シリーズの GPU 搭載 PC 向け)
