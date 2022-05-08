FROM nvcr.io/nvidia/pytorch:22.04-py3

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
    curl -sSL https://deb.nodesource.com/setup_lts.x | bash - &&\
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

RUN echo "20220428_1430"
# install cshogi, tensorrt
RUN pip3 install cshogi nvidia-pyindex nvidia-tensorrt==8.2.3.0

# update jupyterlab
RUN conda install -c conda-forge dask-labextension git jupyterlab jupyterlab-git jupyterlab-language-pack-ja-JP
RUN mkdir -p ~/.jupyter/lab/user-settings/@jupyterlab/translation-extension/
RUN echo '{"locale": "ja_JP"}' > ~/.jupyter/lab/user-settings/@jupyterlab/translation-extension/plugin.jupyterlab-settings

# download suisho5 eval
RUN \
    curl --create-dirs -RLo ~/resource/suisho5_20211123.halfkp.nnue.cpp.xz \
    https://github.com/mizar/YaneuraOu/releases/download/resource/suisho5_20211123.halfkp.nnue.cpp.xz

# download suishopetite eval
RUN \
    curl --create-dirs -RLo ~/resource/suishopetite_20211123.k_p.nnue.cpp.xz \
    https://github.com/mizar/YaneuraOu/releases/download/resource/suishopetite_20211123.k_p.nnue.cpp.xz

# clone git repository
RUN \
    echo "shallow clone : shogi-server" &&\
    git clone https://github.com/mizar/shogi-server.git ~/shogi-server -b wcsc2021 --depth 1 &&\
    echo "shallow clone : usi-tee-ws" &&\
    git clone https://github.com/mizar/usi-tee-ws.git ~/usi-tee-ws -b master --depth 1 &&\
    echo "shallow clone : YaneuraOu master" &&\
    git clone https://github.com/yaneurao/YaneuraOu.git ~/YaneuraOu -b master --depth 1 &&\
    echo "shallow clone : dlshogi master" &&\
    git clone https://github.com/TadaoYamaoka/DeepLearningShogi.git ~/DeepLearningShogi -b master --depth 1

# build fukauraou / yaneuraou / dlshogi engine
RUN \
    echo "build : FukauraOu" &&\
    cd ~/YaneuraOu/source &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_TENSOR_RT EXTRA_CPPFLAGS='-I/usr/local/cuda/include' EXTRA_LDFLAGS='-fuse-ld=lld -lnvrtc -lcuda -L/usr/local/cuda/lib64 -L/usr/local/cuda/lib64/stubs' COMPILER=clang++-14 TARGET_CPU=AVX2 TARGET=/usr/local/bin/FukauraOu-avx2 normal >& >(tee ~/FukauraOu-avx2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_TENSOR_RT clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_TENSOR_RT EXTRA_CPPFLAGS='-I/usr/local/cuda/include' EXTRA_LDFLAGS='-fuse-ld=lld -lnvrtc -lcuda -L/usr/local/cuda/lib64 -L/usr/local/cuda/lib64/stubs' COMPILER=clang++-14 TARGET_CPU=ZEN2 TARGET=/usr/local/bin/FukauraOu-zen2 normal >& >(tee ~/FukauraOu-zen2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_TENSOR_RT clean &&\
    echo "build : Suisho5+YaneuraOu" &&\
    JOBS=`nproc` &&\
    cd ~/YaneuraOu/source &&\
    xz -cdk ~/resource/suisho5_20211123.halfkp.nnue.cpp.xz > eval/nnue/embedded_nnue.cpp &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=AVX2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-normal-avx2 normal >& >(tee ~/Suisho5-YaneuraOu-normal-avx2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=AVX2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-tournament-avx2 tournament >& >(tee ~/Suisho5-YaneuraOu-tournament-avx2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=AVX2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-evallearn-avx2 evallearn >& >(tee ~/Suisho5-YaneuraOu-evallearn-avx2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=AVX2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-gensfen-avx2 gensfen >& >(tee ~/Suisho5-YaneuraOu-gensfen-avx2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=ZEN2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-normal-zen2 normal >& >(tee ~/Suisho5-YaneuraOu-normal-zen2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=ZEN2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-tournament-zen2 tournament >& >(tee ~/Suisho5-YaneuraOu-tournament-zen2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=ZEN2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-evallearn-zen2 evallearn >& >(tee ~/Suisho5-YaneuraOu-evallearn-zen2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=ZEN2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-gensfen-zen2 gensfen >& >(tee ~/Suisho5-YaneuraOu-gensfen-zen2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
    echo "build : dlshogi" &&\
    cd ~/DeepLearningShogi/usi &&\
    nice make -j$(nproc) CC=clang++-14 >& >(tee ~/dlshogi_usi.log) &&\
    mv bin/usi /usr/local/bin/dlshogi_usi &&\
    make clean &&\
    nice make -j$(nproc) CC=clang++-14 make_book >& >(tee ~/dlshogi_make_book.log) &&\
    mv bin/make_book /usr/local/bin/dlshogi_make_book &&\
    make clean

# install dlshogi
RUN \
    cd ~/DeepLearningShogi &&\
    pip install -e .
