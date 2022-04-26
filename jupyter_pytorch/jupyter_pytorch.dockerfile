FROM nvcr.io/nvidia/pytorch:22.03-py3

ENV DEBIAN_FRONTEND noninteractive

# mirror://mirrors.ubuntu.com/mirrors.txt
RUN \
    touch /etc/apt/mirrorlist.txt &&\
    echo "http://azure.archive.ubuntu.com/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://ubuntu-ashisuto.ubuntulinux.jp/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://www.ftp.ne.jp/Linux/packages/ubuntu/archive/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://ftp.riken.jp/Linux/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://ftp.jaist.ac.jp/pub/Linux/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://ubuntutym.u-toyama.ac.jp/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://ftp.tsukuba.wide.ad.jp/Linux/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://mirror.fairway.ne.jp/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://jp.archive.ubuntu.com/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    sed -i.bak -r 's!(deb|deb-src) http://archive\.ubuntu\.com/ubuntu!\1 mirror+file:/etc/apt/mirrorlist.txt!' /etc/apt/sources.list

# install ubuntu packages
RUN \
    apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get -y \
    -o Acquire::Retries="8" \
    -o DPkg::options::="--force-confdef" \
    -o DPkg::options::="--force-confold" \
    upgrade &&\
    DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends \
    -o Acquire::Retries="8" \
    -o DPkg::options::="--force-confdef" \
    -o DPkg::options::="--force-confold" \
    install \
    build-essential ca-certificates curl git gpg language-pack-ja libopenblas-dev p7zip-full p7zip-rar ruby tzdata unzip wget xz-utils vim &&\
    update-locale LANG=ja_JP.UTF-8 &&\
    rm -rf /var/lib/apt/lists/*

# install node.js
RUN \
    curl -sSL https://deb.nodesource.com/setup_18.x | bash - &&\
    DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends \
    -o Acquire::Retries="8" \
    -o DPkg::options::="--force-confdef" \
    -o DPkg::options::="--force-confold" \
    install \
    nodejs &&\
    corepack enable &&\
    apt-get -y clean &&\
    apt-get -y autoclean &&\
    apt-get -y autoremove &&\
    rm -rf /var/lib/apt/lists/*

# install clang-14
RUN \
    curl -sSL "https://apt.llvm.org/llvm-snapshot.gpg.key" | gpg --dearmor -o /usr/share/keyrings/llvm-snapshot.gpg &&\
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/llvm-snapshot.gpg] https://apt.llvm.org/focal/ llvm-toolchain-focal-14 main" | tee /etc/apt/sources.list.d/llvm-toolchain-focal.list > /dev/null &&\
    apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends \
    -o Acquire::Retries="8" \
    -o DPkg::options::="--force-confdef" \
    -o DPkg::options::="--force-confold" \
    install \
    clang-14 llvm-14 libomp-14-dev lld-14 &&\
    apt-get -y clean &&\
    apt-get -y autoclean &&\
    apt-get -y autoremove &&\
    rm -rf /var/lib/apt/lists/*

# TimeZone Asia/Tokyo
ENV TZ Asia/Tokyo
# LANG japanese
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# update jupyterlab
RUN conda install -c conda-forge dask-labextension git jupyterlab jupyterlab-git jupyterlab-language-pack-ja-JP
RUN mkdir -p ~/.jupyter/lab/user-settings/@jupyterlab/translation-extension/
RUN echo '{"locale": "ja_JP"}' > ~/.jupyter/lab/user-settings/@jupyterlab/translation-extension/plugin.jupyterlab-settings 
