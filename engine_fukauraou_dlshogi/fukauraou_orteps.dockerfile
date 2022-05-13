FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

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
    # install ca-certificates, curl, gpg
    apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends \
    -o Acquire::Retries="8" \
    -o DPkg::options::="--force-confdef" \
    -o DPkg::options::="--force-confold" \
    install \
    ca-certificates curl gpg &&\
    mkdir -p /workspace &&\
    # apt source: LLVM
    curl -sSL "https://apt.llvm.org/llvm-snapshot.gpg.key" | gpg --dearmor -o /usr/share/keyrings/llvm-snapshot.gpg &&\
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/llvm-snapshot.gpg] https://apt.llvm.org/focal/ llvm-toolchain-focal-14 main" | tee /etc/apt/sources.list.d/llvm-toolchain-focal.list > /dev/null &&\
    # apt source: Intel OpenVINO
    curl -sSL "https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB" | gpg --dearmor -o /usr/share/keyrings/intel-sw-products.gpg &&\
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/intel-sw-products.gpg] https://apt.repos.intel.com/openvino/2022 focal main" | tee /etc/apt/sources.list.d/intel-openvino-2022.list &&\
    # apt source: cmake
    curl -sSL "https://apt.kitware.com/keys/kitware-archive-latest.asc" | gpg --dearmor -o /usr/share/keyrings/kitware-archive-keyring.gpg &&\
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main" | tee /etc/apt/sources.list.d/kitware.list &&\
    # install other packages
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
    cmake expect git python3 ruby unzip vim-tiny \
    build-essential clang-14 llvm-14 libomp-14-dev lld-14 libopenblas-dev \
    openvino-2022.1.0 \
    &&\
    # clean packages
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

# onnxruntime-openvino build
RUN \
    git clone https://github.com/microsoft/onnxruntime.git ~/onnxruntime -b v1.11.1 --depth 1 &&\
    source /opt/intel/openvino_2022/setupvars.sh &&\
    ~/onnxruntime/build.sh --config RelWithDebInfo --use_dnnl --use_openvino MULTI:MYRIAD,GPU,CPU --build_shared_lib --parallel --enable_lto --skip_tests

# download suisho5 eval
#RUN \
#    curl --create-dirs -RLo ~/resource/suisho5_20211123.halfkp.nnue.cpp.xz \
#    https://github.com/mizar/YaneuraOu/releases/download/resource/suisho5_20211123.halfkp.nnue.cpp.xz

#COPY patch_yaneuraou*.diff ~/

ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/root/onnxruntime/build/Linux/RelWithDebInfo/:/opt/intel/openvino_2022/runtime/3rdparty/tbb/lib/"

RUN \
    echo "20220514_0105" &&\
    echo "shallow clone : shogi-server" &&\
    git clone https://github.com/mizar/shogi-server.git ~/shogi-server -b wcsc2022 --depth 1 &&\
    echo "shallow clone : usi-tee-ws" &&\
    git clone https://github.com/mizar/usi-tee-ws.git ~/usi-tee-ws -b master --depth 1 &&\
    echo "shallow clone : YaneuraOu master" &&\
    #git clone https://github.com/yaneurao/YaneuraOu.git ~/YaneuraOu -b master --depth 1
    git clone https://github.com/mizar/YaneuraOu.git ~/YaneuraOu -b ort_linux --depth 1

#RUN if [ -e ~/patch_yaneuraou.diff ]; then \
#    echo "apply diff : YaneuraOu" &&\
#    cd ~/YaneuraOu &&\
#    git apply ~/patch_yaneuraou.diff;\
#    fi

RUN \
    cd ~/usi-tee-ws &&\
    yarn &&\
    cd /workspace

# build Suisho5 + YaneuraOu
#RUN \
#    echo "build : YaneuraOu" &&\
#    cd ~/YaneuraOu/source &&\
#    xz -cdk ~/resource/suisho5_20211123.halfkp.nnue.cpp.xz > eval/nnue/embedded_nnue.cpp &&\
#    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
#    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=AVX2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-tournament-avx2 tournament >& >(tee ~/Suisho5-YaneuraOu-tournament-avx2.log) &&\
#    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean &&\
#    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON EXTRA_CPPFLAGS='-DENGINE_OPTIONS="\"option=name=FV_SCALE=type=spin=default=24=min=1=max=128\""' COMPILER=clang++-14 EXTRA_LDFLAGS='-fuse-ld=lld' TARGET_CPU=ZEN2 TARGET=/usr/local/bin/Suisho5-YaneuraOu-tournament-zen2 tournament >& >(tee ~/Suisho5-YaneuraOu-tournament-zen2.log) &&\
#    make YANEURAOU_EDITION=YANEURAOU_ENGINE_NNUE EVAL_EMBEDDING=ON clean

# build FukauraOu
RUN \
    echo "build : FukauraOu" &&\
    cd ~/YaneuraOu/source &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_ORT_CPU clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_ORT_CPU EXTRA_CPPFLAGS='-I/root/onnxruntime/include/onnxruntime/core/session -I/root/onnxruntime/include/onnxruntime/core/providers/cpu' EXTRA_LDFLAGS='-fuse-ld=lld -L/root/onnxruntime/build/Linux/RelWithDebInfo' COMPILER=clang++-14 TARGET_CPU=AVX2 TARGET=/usr/local/bin/FukauraOu-cpu normal >& >(tee ~/FukauraOu-cpu.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_ORT_CPU clean &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_ORT_DNNL clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_ORT_DNNL EXTRA_CPPFLAGS='-I/root/onnxruntime/include/onnxruntime/core/session -I/root/onnxruntime/include/onnxruntime/core/providers/dnnl' EXTRA_LDFLAGS='-fuse-ld=lld -L/root/onnxruntime/build/Linux/RelWithDebInfo' COMPILER=clang++-14 TARGET_CPU=AVX2 TARGET=/usr/local/bin/FukauraOu-dnnl normal >& >(tee ~/FukauraOu-dnnl.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_ORT_DNNL clean &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_ORT_VINO clean &&\
    nice make -j$(nproc) YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_ORT_VINO EXTRA_CPPFLAGS='-I/root/onnxruntime/include/onnxruntime/core/session -I/root/onnxruntime/include/onnxruntime/core/providers/openvino' EXTRA_LDFLAGS='-fuse-ld=lld -L/root/onnxruntime/build/Linux/RelWithDebInfo' COMPILER=clang++-14 TARGET_CPU=AVX2 TARGET=/usr/local/bin/FukauraOu-vino normal >& >(tee ~/FukauraOu-vino.log) &&\
    make YANEURAOU_EDITION=YANEURAOU_ENGINE_DEEP_ORT_VINO clean
