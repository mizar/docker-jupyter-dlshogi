FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

# mirror://mirrors.ubuntu.com/mirrors.txt
RUN \
    touch /etc/apt/mirrorlist.txt &&\
    echo "http://azure.archive.ubuntu.com/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    #echo "http://ubuntu-ashisuto.ubuntulinux.jp/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    #echo "http://www.ftp.ne.jp/Linux/packages/ubuntu/archive/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://ftp.riken.jp/Linux/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    echo "http://ftp.jaist.ac.jp/pub/Linux/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    #echo "http://ubuntutym.u-toyama.ac.jp/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    #echo "http://ftp.tsukuba.wide.ad.jp/Linux/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    #echo "http://mirror.fairway.ne.jp/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    #echo "http://jp.archive.ubuntu.com/ubuntu/" >> /etc/apt/mirrorlist.txt &&\
    sed -i.bak -r 's!(deb|deb-src) http://archive\.ubuntu\.com/ubuntu!\1 mirror+file:/etc/apt/mirrorlist.txt!' /etc/apt/sources.list

RUN \
    export DEBIAN_FRONTEND=noninteractive &&\
    apt-get update &&\
    apt-get -y --no-install-recommends -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" install \
    ca-certificates curl gpg gpg-agent &&\
    mkdir -p /workspace &&\
    curl "https://apt.llvm.org/llvm-snapshot.gpg.key" | gpg --no-default-keyring --keyring /usr/share/keyrings/llvm-snapshot.gpg --import - &&\
    echo "deb [signed-by=/usr/share/keyrings/llvm-snapshot.gpg] https://apt.llvm.org/focal/ llvm-toolchain-focal-14 main" | tee /etc/apt/sources.list.d/llvm-toolchain-focal.list &&\
    curl "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin" -o /etc/apt/preferences.d/cuda-repository-pin-600 &&\
    curl "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub" | gpg --no-default-keyring --keyring /usr/share/keyrings/cuda.gpg --import - &&\
    echo "deb [signed-by=/usr/share/keyrings/cuda.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" | tee /etc/apt/sources.list.d/cuda.list &&\
    apt-get update &&\
    apt-get -y --no-install-recommends -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" install \
    expect git ruby unzip vim-tiny \
    build-essential clang-14 llvm-14 libomp-14-dev lld-14 libopenblas-dev \
    cuda-minimal-build-11-6 cuda-nvrtc-dev-11-6 \
    libcudnn8-dev \
    libnvinfer-dev libnvinfer-plugin-dev libnvonnxparsers-dev libnvparsers-dev \
    &&\
    apt-get -y clean &&\
    apt-get -y autoclean &&\
    apt-get -y autoremove &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm -rf /usr/share/doc/*

# node.js
RUN \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - &&\
    apt-get -y --no-install-recommends \
    -o DPkg::options::="--force-confdef" \
    -o DPkg::options::="--force-confold" \
    install \
    nodejs &&\
    corepack enable &&\
    rm -rf /var/lib/apt/lists/* &&\
    rm -rf /usr/share/doc/*

ENV PATH $PATH:/usr/local/cuda/bin

WORKDIR /workspace

# download suisho5 eval
# RUN curl --create-dirs -RLo ~/resource/suisho5_20211123.halfkp.nnue.cpp.xz https://github.com/mizar/YaneuraOu/releases/download/resource/suisho5_20211123.halfkp.nnue.cpp.xz

#COPY patch_yaneuraou*.diff ~/
#COPY patch_dlshogi*.diff ~/

RUN \
    echo "shallow clone : shogi-server" &&\
    git clone https://github.com/mizar/shogi-server.git ~/shogi-server -b wcsc2022 --depth 1 &&\
    echo "shallow clone : usi-tee-ws" &&\
    git clone https://github.com/mizar/usi-tee-ws.git ~/usi-tee-ws -b master --depth 1 &&\
    echo "shallow clone : YaneuraOu master" &&\
    git clone https://github.com/yaneurao/YaneuraOu.git ~/YaneuraOu -b master --depth 1 &&\
    echo "shallow clone : dlshogi master" &&\
    git clone https://github.com/TadaoYamaoka/DeepLearningShogi.git ~/DeepLearningShogi -b master --depth 1

#RUN if [ -e ~/patch_yaneuraou.diff ]; then \
#    echo "apply diff : YaneuraOu" &&\
#    cd ~/YaneuraOu &&\
#    git apply ~/patch_yaneuraou.diff;\
#    fi

#RUN if [ -e ~/patch_dlshogi.diff ]; then \
#    echo "apply diff : DeepLearningShogi" &&\
#    cd ~/DeepLearningShogi/ &&\
#    git apply ~/patch_dlshogi.diff;\
#    fi

RUN \
    cd ~/usi-tee-ws &&\
    yarn &&\
    cd /workspace

# build Suisho5 + YaneuraOu
RUN \
    #echo "build : YaneuraOu" &&\
    #cd ~/YaneuraOu/source &&\
    #xz -cdk ~/resource/suisho5_20211123.halfkp.nnue.cpp.xz > eval/nnue/embedded_nnue.cpp &&\
    #nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=AVX2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-tournament-avx2 tournament >& >(tee ~/Suisho5-YaneuraOu-tournament-avx2.log) &&\
    #make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
    #nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=ZEN2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-tournament-zen2 tournament >& >(tee ~/Suisho5-YaneuraOu-tournament-zen2.log) &&\
    #make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
    echo "build : FukauraOu" &&\
    cd ~/YaneuraOu/source &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_TENSOR_RT EXTRA_CPPFLAGS='-I/usr/local/cuda/include' EXTRA_LDFLAGS='-fuse-ld=lld -lnvrtc -lcuda -L/usr/local/cuda/lib64 -L/usr/local/cuda/lib64/stubs' COMPILER=clang++-14 TARGET_CPU=AVX2 TARGET=/usr/local/bin/FukauraOu-avx2 normal >& >(tee ~/FukauraOu-avx2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_TENSOR_RT clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_TENSOR_RT EXTRA_CPPFLAGS='-I/usr/local/cuda/include' EXTRA_LDFLAGS='-fuse-ld=lld -lnvrtc -lcuda -L/usr/local/cuda/lib64 -L/usr/local/cuda/lib64/stubs' COMPILER=clang++-14 TARGET_CPU=ZEN2 TARGET=/usr/local/bin/FukauraOu-zen2 normal >& >(tee ~/FukauraOu-zen2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_TENSOR_RT clean

RUN \
    echo "build : dlshogi" &&\
    cd ~/DeepLearningShogi/usi &&\
    nice make -j$(nproc) CC=clang++-14 >& >(tee ~/dlshogi_usl.log) &&\
    mv bin/usi /usr/local/bin/dlshogi_usi &&\
    make clean &&\
    nice make -j$(nproc) CC=clang++-14 make_book >& >(tee ~/dlshogi_make_book.log) &&\
    mv bin/make_book /usr/local/bin/dlshogi_make_book &&\
    make clean
