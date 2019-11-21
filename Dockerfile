
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
# This is a copy of the file from https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu.Dockerfile with some changes,
# Please see the Readme.md for these changes

ARG UBUNTU_VERSION=18.04
ARG CUDA=10.1
FROM nvidia/cuda:${CUDA}-base-ubuntu${UBUNTU_VERSION}
# ARCH and CUDA are specified again because the FROM directive resets ARGs
# (but their default value is retained if set previously)
ARG CUDA
ARG CUDNN=7.6.4.38-1

# Needed for string substitution
SHELL   ["/bin/bash", "-c"]
RUN     apt-get update && apt-get install -y --no-install-recommends \
            build-essential \
            cuda-command-line-tools-${CUDA/./-} \
            cuda-cublas-10-0 \
            cuda-cufft-${CUDA/./-} \
            cuda-curand-${CUDA/./-} \
            cuda-cusolver-${CUDA/./-} \
            cuda-cusparse-${CUDA/./-} \
            curl \
            libcudnn7=${CUDNN}+cuda${CUDA} \
            libfreetype6-dev \
            libhdf5-serial-dev \
            libzmq3-dev \
            pkg-config \
            software-properties-common \
            unzip

RUN     apt-get update \
            && apt-get install -y --no-install-recommends libnvinfer5=5.1.5-1+cuda${CUDA} \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
# dynamic linker run-time bindings
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 \
    && echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf \
    && ldconfig

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8
# Install python 3.8
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/ppa \
        && apt install -y python3.8 python3-pip
RUN python3.8 -m pip --no-cache-dir install --upgrade \
    pip \
    setuptools
    
# Some TF tools expect a "python" binary
RUN ln -s $(which python3.8) /usr/local/bin/python

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    wget \
    python3.8-dev \
    swig

# Install tensorflow
ARG     TENSORFLOW_WHL=tensorflow-2.0.0-cp38-cp38-linux_x86_64.whl
ARG     TENSORFLOW_PATH="tensorflow_pkg"
COPY    ${TENSORFLOW_PATH}/${TENSORFLOW_WHL} .
RUN     pip3 install ${TENSORFLOW_WHL} && rm ${TENSORFLOW_WHL}

COPY bashrc /etc/bash.bashrc
RUN chmod a+rwx /etc/bash.bashrc
