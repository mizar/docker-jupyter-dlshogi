# JupyterLab + PyTorch + dlshogi 機械学習環境サンプル

- [NVIDIA_Deep_Learning_Container_License.pdf](https://developer.download.nvidia.com/licenses/NVIDIA_Deep_Learning_Container_License.pdf) への同意
- `jupyter_dlshogi.dockerfile` : Jupyter + dlshogi 環境構築手順ファイル
- `README.md` : このファイル
## 準備 : 学習用データセットのダウンロード
- `x07_gct-dlshogi-denryu2020.bat` : [dlshogi with GCT 第31回世界コンピュータ将棋選手権バージョン](https://github.com/TadaoYamaoka/DeepLearningShogi/releases/tag/wcwc31)のダウンロード
- `x07_rclone_aobazero.bat` : AobaZero学習用棋譜
  cf. [AobaZero](http://www.yss-aya.com/aobazero/)
- `x07_rclone_aobakomaochi.bat` : Aoba駒落ち学習用棋譜
  cf. [Aoba駒落ち](http://www.yss-aya.com/komaochi/)
- `x07_rclone_gct.bat` : dlshogi with GCTのWCSC31バージョンのモデルの学習に使用したデータセット
  cf. [2021-05-06 GCTの学習に使用したデータセットを公開](https://tadaoyamaoka.hatenablog.com/entry/2021/05/06/223701)
- `x07_rclone_tayayan.bat` : [たややん@水匠](https://twitter.com/tayayan_ts) 公開Google Driveファイル
## 準備 : JupyterLab 環境の構築とパスワード設定
- `x09_mkpasswd.bat` : JupyterLab環境の構築・パスワード設定
## JupyterLab
- `x10_jupyter_run__standard.bat` : JupyterLab の起動
- `x11_jupyter_page__standard.bat` : JupyterLab アクセス用ページを開く
## その他
- `x20_rebuild__standard.bat` : JupyterLab 環境の再構築
- `x30_kill__standard.bat` : JupyterLab 環境の強制終了
- `x40_bash__standard.bat` : bash 端末の起動
- `x90_delete_rclone_conf.bat` : rclone の設定ファイルを削除(rclone から Google Drive へのアカウント連携に失敗して再設定が必要な時に)
