# Copyright 2018 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============================================================================
#
# This is a copy of the file from https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/devel-gpu.Dockerfile with some changes,
# Please see the Readme.md for these changes


ARG UBUNTU_VERSION=18.04
ARG CUDA=10.1
FROM nvidia/cuda:${CUDA}-base-ubuntu${UBUNTU_VERSION}
# ARCH and CUDA are specified again because the FROM directive resets ARGs
# (but their default value is retained if set previously)
ARG CUDA
ARG CUDNN=7.6.4.38-1
ARG CUDNN_MAJOR_VERSION=7
ARG LIB_DIR_PREFIX=x86_64

# Needed for string substitution 
# for Cublas, there was a change in the naming. See https://devtalk.nvidia.com/default/topic/1047981/cuda-setup-and-installation/cublas-for-10-1-is-missing/
SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-${CUDA/./-} \
        libcublas-dev \
        cuda-cudart-dev-${CUDA/./-} \
        cuda-cufft-dev-${CUDA/./-} \
        cuda-curand-dev-${CUDA/./-} \
        cuda-cusolver-dev-${CUDA/./-} \
        cuda-cusparse-dev-${CUDA/./-} \
        libcudnn7=${CUDNN}+cuda${CUDA} \
        libcudnn7-dev=${CUDNN}+cuda${CUDA} \
        libcurl3-dev \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        software-properties-common \
        unzip \
        zip \
        zlib1g-dev \
        wget \
        git \
        && \
    find /usr/local/cuda-${CUDA}/lib64/ -type f -name 'lib*_static.a' -not -name 'libcudart_static.a' -delete && \
    rm /usr/lib/${LIB_DIR_PREFIX}-linux-gnu/libcudnn_static_v7.a

RUN apt-get update && \
        apt-get install -y --no-install-recommends libnvinfer5=5.1.5-1+cuda${CUDA} \
        libnvinfer-dev=5.1.5-1+cuda${CUDA} \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*;

# Configure the build for our CUDA configuration.
ENV CI_BUILD_PYTHON python3.7
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV TF_NEED_CUDA 1
ENV TF_NEED_TENSORRT 1
ARG TF_CUDA_COMPUTE_CAPABILITIES=6.1,7.0
ENV TF_CUDA_VERSION=${CUDA}
ENV TF_CUDNN_VERSION=${CUDNN_MAJOR_VERSION}
# CACHE_STOP is used to rerun future commands, otherwise cloning tensorflow will be cached and will not pull the most recent version
ARG CACHE_STOP=1

# Prepare tensorflow source code
RUN git clone https://github.com/tensorflow/tensorflow.git /tensorflow_src && \
    cd /tensorflow_src && \
    git checkout r2.0

# Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
# dynamic linker run-time bindings
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 \
    && echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf \
    && ldconfig

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

# Install python 3.7
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/ppa \
        && apt install -y python3.7 python3-pip
RUN python3.7 -m pip --no-cache-dir install --upgrade \
    pip \
    setuptools
    


# Some TF tools expect a "python" binary
RUN ln -s $(which python3.7) /usr/local/bin/python 

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    wget \
    openjdk-8-jdk \
    python3.7-dev \
    swig

RUN pip --no-cache-dir install \
    Pillow \
    h5py \
    keras_applications \
    keras_preprocessing \
    matplotlib \
    mock \
    numpy \
    scipy \
    sklearn \
    pandas \
    future \
    portpicker \
    enum34

# Install bazel
ARG BAZEL_VERSION=0.26.1
RUN mkdir /bazel && \
    wget -O /bazel/installer.sh "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh" && \
    wget -O /bazel/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE" && \
    chmod +x /bazel/installer.sh && \
    /bazel/installer.sh && \
    rm -f /bazel/installer.sh

ENV     PYTHON_BIN_PATH=/usr/bin/python3.7
ENV     USE_DEFAULT_PYTHON_LIB_PATH=1
ENV     TF_ENABLE_XLA=1
ENV     TF_NEED_OPENCL_SYCL=0
ENV     TF_NEED_ROCM=0
ENV     TF_CUDA_CLANG=0
ENV     GCC_HOST_COMPILER_PATH=/usr/bin/gcc
ENV     TF_NEED_MPI=0
ENV     CC_OPT_FLAGS="-march=native -Wno-sign-compare"
ENV     TF_SET_ANDROID_WORKSPACE=0

ENV     TF_CUDA_PATHS=/lib/x86_64-linux-gnu,/usr,/usr/lib/x86_64-linux-gnu,/usr/local/cuda,/usr/local/cuda-10.1,/usr/local/cuda-10.1,targets/x86_64-linux/lib,/usr/local/cuda-10.0/targets/x86_64-linux/

WORKDIR /tensorflow_src
RUN     ./configure

# moved in makefile
# ARG OPTIONS=1
# CMD     bazel build \
#             ${OPTIONS} \
#             --config=cuda \
#             --config=noaws \
#             --config=nohdfs \
#             --config=noignite \
#             --config=nokafka \
#             //tensorflow/tools/pip_package:build_pip_package && \
#         ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tensorflow_pkg

# see https://nvidia.github.io/OpenSeq2Seq/html/installation.html for options
# CMD     bazel build --config=opt --config=cuda --copt=-mavx --copt=-mavx2 \
#             --copt=-mfma --copt=-mfpmath=both --copt=-msse4.2 --copt=-O3 \
#             --config=noaws \
#             --config=nohdfs \
#             --config=noignite \
#             --config=nokafka \
#             --config=v2 \
#             //tensorflow/tools/pip_package:build_pip_package && \
        # bazel-bin/tensorflow/tools/pip_package/build_pip_package --gpu --nightly_flag /tensorflow_pkg



