# tensorflow-compiler
Code to compile tensorflow inside docker.
The structure of the project is explained in [this article](https://net-mist.github.io/tfcompile)

# Sources:
  - Archlinux wiki: https://git.archlinux.org/svntogit/community.git/plain/trunk/PKGBUILD?h=packages/tensorflow
  - https://github.com/tensorflow/benchmarks/issues/272

# Benchmark

To build the benchmark image and run it run:
```bash
export BASE_IMAGE=netmist/tensorflow:2.0.0 && make build_bench
export BASE_IMAGE=netmist/tensorflow:2.0.0 && make bench

export BASE_IMAGE=tensorflow/tensorflow:2.0.0-gpu-py3 && make build_bench
export BASE_IMAGE=tensorflow/tensorflow:2.0.0-gpu-py3 && make bench
```

Size:
netmist/tensorflow:2.0.0             | 3.33GB
tensorflow/tensorflow:2.0.0-gpu-py3  | 3.42GB

## FPS on a computer with Quadro P4000 + I7-7700

| Models            | (1) | (2) | (3) |
|-------------------|:---:|:---:|:---:|
| ResNet50          |  88 |  82 |  84 |
| InceptionV3       |  52 |  46 |  48 |
| MobileNetv2       | 199 | 167 | 168 |

(1) Archlinux tensorflow-opt-cuda 2.0.0-5 package
(2) tensorflow/tensorflow:2.0.0-gpu-py3
(3) netmist/tensorflow:2.0.0
