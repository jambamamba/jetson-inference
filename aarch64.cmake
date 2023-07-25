#For crosscompiling for aarch64 target on x86_64 host machine

# sudo apt install -y gcc-aarch64-linux-gnu
# sudo apt install -y g++-aarch64-linux-gnu
# sudo apt install -y binutils-aarch64-linux-gnu

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1)

set(prefix "/usr/bin/aarch64-linux-gnu-")
set(CMAKE_C_COMPILER   ${prefix}gcc)
set(CMAKE_CXX_COMPILER ${prefix}g++)
set(CMAKE_STRIP ${prefix}strip)
set(CMAKE_AR ${prefix}ar)
set(CMAKE_NM ${prefix}nm)
set(CMAKE_DUMP ${prefix}dump)
set(CMAKE_LD ${prefix}ld)

# set(CMAKE_FIND_ROOT_PATH /usr/aarch64-linux-gnu)
# set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
# set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CUDA_TOOLKIT_ROOT_DIR "/usr/local/aarch64/cuda-11.4")
set(CUDA_CUDART_LIBRARY "/usr/local/aarch64/cuda-11.4/lib64/libcudart.so")
set(CUDA_TOOLKIT_INCLUDE "/usr/local/aarch64/cuda-11.4/include")


