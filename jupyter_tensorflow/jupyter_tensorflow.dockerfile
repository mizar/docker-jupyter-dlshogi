FROM nvcr.io/nvidia/tensorflow:21.12-tf1-py3

ENV DEBIAN_FRONTEND noninteractive

# mirror://mirrors.ubuntu.com/mirrors.txt
RUN \
    touch /etc/apt/mirrorlist.txt &&\
    echo "http://ubuntu-ashisuto.ubuntulinux.jp/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://www.ftp.ne.jp/Linux/packages/ubuntu/archive/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://ftp.riken.jp/Linux/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://ftp.jaist.ac.jp/pub/Linux/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://ubuntutym.u-toyama.ac.jp/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://ftp.tsukuba.wide.ad.jp/Linux/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://mirror.fairway.ne.jp/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    sed -i.bak -r 's!(deb|deb-src) http://archive\.ubuntu\.com/ubuntu!\1 mirror+file:/etc/apt/mirrorlist.txt!' /etc/apt/sources.list

# install ubuntu packages
RUN \
    apt-get update &&\
    apt-get -y \
    -o DPkg::options::="--force-confdef" \
    -o DPkg::options::="--force-confold" \
    upgrade &&\
    apt-get -y --no-install-recommends \
    -o DPkg::options::="--force-confdef" \
    -o DPkg::options::="--force-confold" \
    install \
    build-essential ca-certificates curl git gnupg2 language-pack-ja libopenblas-dev p7zip-full p7zip-rar ruby tzdata unzip wget xz-utils vim &&\
    update-locale LANG=ja_JP.UTF-8 &&\
    rm -rf /var/lib/apt/lists/*

# clang-13 repository
RUN \
    curl "https://apt.llvm.org/llvm-snapshot.gpg.key" | gpg --no-default-keyring --keyring /usr/share/keyrings/llvm-snapshot.gpg --import - &&\
    echo "deb [signed-by=/usr/share/keyrings/llvm-snapshot.gpg] https://apt.llvm.org/focal/ llvm-toolchain-focal-13 main" | tee /etc/apt/sources.list.d/llvm-toolchain-focal.list;

# install clang-13
RUN \
    apt-get update &&\
    apt-get -y --no-install-recommends -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" install \
    clang-13 llvm-13 libomp-13-dev lld-13 &&\
    apt-get -y clean &&\
    apt-get -y autoclean &&\
    apt-get -y autoremove &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm -rf /usr/share/doc/*

# TimeZone Asia/Tokyo
ENV TZ Asia/Tokyo
# LANG japanese
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# update jupyterlab
RUN pip install --upgrade dask-labextension jupyterlab jupyterlab-git jupyterlab-language-pack-ja-JP
RUN mkdir -p ~/.jupyter/lab/user-settings/@jupyterlab/translation-extension/
RUN echo '{"locale": "ja_JP"}' > ~/.jupyter/lab/user-settings/@jupyterlab/translation-extension/plugin.jupyterlab-settings 
