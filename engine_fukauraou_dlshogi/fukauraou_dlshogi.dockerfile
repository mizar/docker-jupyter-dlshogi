FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

#ENV NV_CUDA_SUFFIX "11-4"
#ENV NV_CUDA_SUFFIX "11-6"
ENV NV_CUDA_SUFFIX "11-7"

#ENV NV_CUDNN_VERSION 8.2.4.15-1+cuda11.4
ENV NV_CUDNN_VERSION 8.4.0.27-1+cuda11.6

ENV NV_INFER_VERSION 8.2.4-1+cuda11.4

ENV NV_CUDNN_PACKAGE "libcudnn8=$NV_CUDNN_VERSION"
ENV NV_CUDNN_PACKAGE_DEV "libcudnn8-dev=$NV_CUDNN_VERSION"
ENV NV_CUDNN_PACKAGE_NAME "libcudnn8"

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

RUN \
    apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends \
    -o Acquire::Retries="8" \
    -o DPkg::options::="--force-confdef" \
    -o DPkg::options::="--force-confold" \
    install \
    ca-certificates curl gpg &&\
    mkdir -p /workspace &&\
    curl -sSL "https://apt.llvm.org/llvm-snapshot.gpg.key" | gpg --dearmor -o /usr/share/keyrings/llvm-snapshot.gpg &&\
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/llvm-snapshot.gpg] https://apt.llvm.org/focal/ llvm-toolchain-focal-14 main" | tee /etc/apt/sources.list.d/llvm-toolchain-focal.list > /dev/null &&\
    curl -sSL "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin" -o /etc/apt/preferences.d/cuda-repository-pin-600 &&\
    curl -sSL "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004-keyring.gpg" -o /usr/share/keyrings/cuda-archive-keyring.gpg &&\
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /" | tee /etc/apt/sources.list.d/cuda-ubuntu2004-x86_64.list > /dev/null &&\
    apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends \
    -o Acquire::Retries="8" \
    -o DPkg::options::="--force-confdef" \
    -o DPkg::options::="--force-confold" \
    upgrade &&\
    DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends \
    -o Acquire::Retries="8" \
    -o DPkg::options::="--force-confdef" \
    -o DPkg::options::="--force-confold" \
    install \
    expect git ruby unzip vim-tiny \
    build-essential clang-14 llvm-14 libomp-14-dev lld-14 libopenblas-dev \
    cuda-minimal-build-${NV_CUDA_SUFFIX} cuda-nvrtc-dev-${NV_CUDA_SUFFIX} libcublas-${NV_CUDA_SUFFIX} libcublas-dev-${NV_CUDA_SUFFIX} \
    ${NV_CUDNN_PACKAGE} ${NV_CUDNN_PACKAGE_DEV} \
    libnvinfer8=${NV_INFER_VERSION} libnvonnxparsers8=${NV_INFER_VERSION} libnvparsers8=${NV_INFER_VERSION} libnvinfer-plugin8=${NV_INFER_VERSION} \
    libnvinfer-dev=${NV_INFER_VERSION} libnvinfer-plugin-dev=${NV_INFER_VERSION} libnvonnxparsers-dev=${NV_INFER_VERSION} libnvparsers-dev=${NV_INFER_VERSION} \
    python3-libnvinfer=${NV_INFER_VERSION} \
    &&\
    apt-mark hold \
    ${NV_CUDNN_PACKAGE_NAME} \
    libnvinfer8 libnvinfer-plugin8 libnvonnxparsers8 libnvparsers8 \
    libnvinfer-dev libnvinfer-plugin-dev libnvonnxparsers-dev libnvparsers-dev \
    python3-libnvinfer \
    &&\
    apt-get -y clean &&\
    apt-get -y autoclean &&\
    apt-get -y autoremove &&\
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

ENV PATH ${PATH}:/usr/local/cuda/bin

WORKDIR /workspace

# download suisho5 eval
RUN curl --create-dirs -RLo ~/resource/suisho5_20211123.halfkp.nnue.cpp.xz https://github.com/mizar/YaneuraOu/releases/download/resource/suisho5_20211123.halfkp.nnue.cpp.xz

#COPY patch_yaneuraou*.diff ~/
#COPY patch_dlshogi*.diff ~/

# download onnxruntime
RUN \
    curl --create-dirs -RLo ~/resource/onnxruntime-linux-x64-1.11.1.tgz https://github.com/microsoft/onnxruntime/releases/download/v1.11.1/onnxruntime-linux-x64-1.11.1.tgz &&\
    tar xvf ~/resource/onnxruntime-linux-x64-1.11.1.tgz -C ~ &&\
    cp ~/onnxruntime-linux-x64-1.11.1/lib/*.so* /usr/local/lib &&\
    ldconfig
#ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/onnxruntime-linux-x64-1.11.1/lib"

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
    echo "build : YaneuraOu" &&\
    cd ~/YaneuraOu/source &&\
    xz -cdk ~/resource/suisho5_20211123.halfkp.nnue.cpp.xz > eval/nnue/embedded_nnue.cpp &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=AVX2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-tournament-avx2 tournament >& >(tee ~/Suisho5-YaneuraOu-tournament-avx2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=ZEN2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-tournament-zen2 tournament >& >(tee ~/Suisho5-YaneuraOu-tournament-zen2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean

# build FukauraOu
RUN \
    echo "build : FukauraOu" &&\
    cd ~/YaneuraOu/source &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_ORT_CPU clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_ORT_CPU EXTRA_CPPFLAGS='-I/root/onnxruntime-linux-x64-1.11.1/include' EXTRA_LDFLAGS='-fuse-ld=lld -L/root/onnxruntime-linux-x64-1.11.1/lib' COMPILER=clang++-14 TARGET_CPU=AVX2 TARGET=/usr/local/bin/FukauraOu-cpu normal >& >(tee ~/FukauraOu-cpu.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_ORT_CPU clean &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_TENSOR_RT clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_TENSOR_RT EXTRA_CPPFLAGS='-I/usr/local/cuda/include' EXTRA_LDFLAGS='-fuse-ld=lld -L/usr/local/cuda/lib64 -L/usr/local/cuda/lib64/stubs' COMPILER=clang++-14 TARGET_CPU=AVX2 TARGET=/usr/local/bin/FukauraOu-avx2 normal >& >(tee ~/FukauraOu-avx2.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_TENSOR_RT clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_TENSOR_RT EXTRA_CPPFLAGS='-I/usr/local/cuda/include' EXTRA_LDFLAGS='-fuse-ld=lld -L/usr/local/cuda/lib64 -L/usr/local/cuda/lib64/stubs' COMPILER=clang++-14 TARGET_CPU=ZEN2 TARGET=/usr/local/bin/FukauraOu-zen2 normal >& >(tee ~/FukauraOu-zen2.log) &&\
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
