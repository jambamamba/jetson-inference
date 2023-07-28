#!/bin/bash -xe
set -xe


function parseArgs(){
   for change in "$@"; do
      local name="${change%%=*}"
      local value="${change#*=}"
      eval $name="$value"
   done
}

function build(){
    local clean="false"
    parseArgs $@
    export CROSS_COMPILE_AARCH64=/l4t/toolchain/bin/aarch64-buildroot-linux-gnu- 
    export CROSS_COMPILE_AARCH64_PATH=/l4t/toolchain 
    export UEFI_STMM_PATH=/Linux_for_Tegra/bootloader/standalonemm_optee_t234.bin
    export CROSS_COMPILE=aarch64-linux-gnu-
    export CUDA_CUDART_LIBRARY=/usr/local/cuda-11.4/lib64/libcudart.so
    export CUDA_TOOLKIT_INCLUDE=/usr/local/cuda-11.4/include
    export CUDA_INSTALL_DIR=/usr/local/cuda 
    export CUDNN_INSTALL_DIR=/usr/lib/aarch64-linux-gnu/
    export PYTHON3_PATH=/usr/bin/python3.8
    export TARGET_ROOTFS=/l4t/targetfs/

    # sudo apt update -y
    # sudo apt install -y doxygen vim nano file wget rsync less language-pack-en-base tzdata
    # rsync -uav --progress /home/isgdev/downloads/orin/gstreamer-1.0 /usr/include/

    # mkdir -p /Linux_for_Tegra
    # pushd /
    # tar -I lbzip2 -xf /home/isgdev/downloads/orin/Jetson_Linux_R35.3.1_aarch64.tbz2
    # popd

    # pushd /l4t
    # tar -I lbzip2 -xf targetfs.tbz2
    # mkdir toolchain
    # tar -C toolchain -xf toolchain.tar.gz
    # /opt/nvidia/vpi2/bin/vpi_install_samples.sh .
    # popd

    # mkdir -p /lib/aarch64-linux-gnu/
    # ln -sf /home/isgdev/downloads/orin/aarch64-linux-gnu/libc.so.6 /lib/aarch64-linux-gnu/libc.so.6
    # ln -sf /home/isgdev/downloads/orin/aarch64-linux-gnu/libc_nonshared.a /lib/aarch64-linux-gnu/libc_nonshared.a
    # ln -sf /home/isgdev/downloads/orin/aarch64-linux-gnu/ld-linux-aarch64.so.1 /lib/aarch64-linux-gnu/ld-linux-aarch64.so.1

    # sudo apt install -y qt5*
    # mv /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8 /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8.original
    # ln -sf /home/isgdev/downloads/orin/aarch64-linux-gnu/libQt5Widgets.so.5.12.8 /usr/lib/x86_64-linux-gnu/libQt5Widgets.so.5.12.8 
    # mv /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8 /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8.original
    # ln -sf /home/isgdev/downloads/orin/aarch64-linux-gnu/libQt5Gui.so.5.12.8 /usr/lib/x86_64-linux-gnu/libQt5Gui.so.5.12.8 
    # mv /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8 /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8.original
    # ln -sf /home/isgdev/downloads/orin/aarch64-linux-gnu/libQt5Core.so.5.12.8 /usr/lib/x86_64-linux-gnu/libQt5Core.so.5.12.8 

    local curdir="$(pwd)"
    mkdir -p build
    pushd build
    if [ ${clean} == "true" ]; then
        rm -fr *
    fi

    # export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/isgdev/downloads/orin/aarch64-linux-gnu/
    cmake \
        -DCMAKE_TOOLCHAIN_FILE=${curdir}/Toolchain_aarch64_l4t.cmake \
        -DCUDA_CUDART_LIBRARY=/usr/local/aarch64/cuda-11.4/lib64/libcudart.so \
        -DCUDA_TOOLKIT_INCLUDE=/usr/local/cuda-11.4/include \
        -DCUDA_INCLUDE_DIRS=/usr/local/cuda-11.4/include \
        -DCMAKE_MODULE_PATH=${curdir}/cmake-modules \
        -DCMAKE_PREFIX_PATH=${curdir}/cmake-modules \
        -DOpenCV_DIR=${curdir}/cmake-modules \
        -DCUDA_nppicc_LIBRARY=/usr/local/cuda-11.4/targets/aarch64-linux/lib/stubs/libnppicc.so \
        -DQt5_DIR=/usr/lib/x86_64-linux-gnu/cmake/Qt5/ \
        -DQt5Widgets_DIR=/usr/lib/x86_64-linux-gnu/cmake/Qt5Widgets/ \
        -DQt5Gui_DIR=/usr/lib/x86_64-linux-gnu/cmake/Qt5Gui/ \
        -DQt5Core_DIR=/usr/lib/x86_64-linux-gnu/cmake/Qt5Core/ \
        -DCUDA_CUDART_LIBRARY=/usr/local/cuda-11.4/lib64/libcudart.so \
        -DCUDA_TOOLKIT_INCLUDE=/usr/local/cuda-11.4/include \
        -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-11.4/ \
        -DCMAKE_CXX_FLAGS=-I/usr/lib/x86_64-linux-gnu/glib-2.0/include/\ -I/usr/local/cuda-11.4/samples/common/inc/ \
        -DCMAKE_CXX_STANDARD_LIBRARIES=-L/usr/aarch64-linux-gnu/ \
        ..

    local SOC_SMS=87
    # VERBOSE=1 \
    make TARGET=aarch64 TARGET_OS=linux TARGET_FS=/l4t/targetfs/ SMS=${SOC_SMS} -j8
    popd
}

function deploy(){
    local ip=""
    parseArgs $@

    if [ "${ip}" == "" ]; then
        return
    fi

    local bindir="/home/isgdev/bin"
    local dst="isgdev@${ip}:${bindir}"

    ssh isgdev@${ip} mkdir -p ${bindir}
    scp ./build/aarch64/bin/imagenet ${dst}/
    scp ./build/aarch64/bin/detectnet ${dst}/
    scp ./build/aarch64/bin/segnet ${dst}/
    scp ./build/aarch64/bin/posenet ${dst}/
    scp runexamples.sh ${dst}/
}


function main(){
    local deploy=""
    local clean="true"
    parseArgs $@

    time build clean="${clean}"
    if [ "${deploy}" != "" ]; then
       deploy ip="${deploy}"
    fi
}

main $@
