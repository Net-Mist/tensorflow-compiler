# tensorflow-compiler
Code to compile tensorflow inside docker.
The structure of the project is explained in [this article](https://net-mist.github.io/tfcompile)

Currently support:
  - opt : build the image with -march=native. You will have all the optimisations supported by your computer
  - avx2, avx512f and fma: for computer with large amount of CPU cores. Support cuda compute compatibility > 6.0 or > 6.1
  - avx2 and fma: for most computer

tensorflow/tensorflow:1.14.0-gpu-py3
docker run -it --rm --runtime=nvidia tensorflow/tensorflow:1.14.0-gpu-py3 bash
When open a tensorflow session:
Your CPU supports instructions that this TensorFlow binary was not compiled to use: AVX2 AVX512F FMA


TODO
  - update to ubuntu 19.04 with python 3.7 support
  - check option --gpu when building pip package
  
This stackoferflow is quite complete :https://stackoverflow.com/questions/41293077/how-to-compile-tensorflow-with-sse4-2-and-avx-instructions
add -nogcp and implement https://github.com/tensorflow/tensorflow/issues/29617

# Benchmark

To build the benchmark image run:
```bash
export BASE_IMAGE=netmist/tensorflow:1.14.0-avx2-fma
make build_bench
make bench
```

Size:
netmist/tensorflow:1.14.0-avx2-avx512f-fma-6.0 | 3.05GB
netmist/tensorflow:1.14.0-avx2-fma             | 2.87GB
netmist/tensorflow:1.14.0-avx2-avx512f-fma     | 2.87GB
tensorflow/tensorflow:1.14.0-gpu-py3           | 3.51GB


docker run -it --rm tensorflow/tensorflow:1.14.0-py3 bash

## FPS on a computer with GTX1080 + I7-8700K

| Models            | (1) | (2) |
|-------------------|:---:|:---:|
| ResNet50          | 102 | 96  |
| InceptionV3       | 61  | 54  |
| InceptionResNetV2 | 27  | 24  |
| VGG16             | 102 | 102 |
| Xception          | 94  | 83  |
| MobileNet         | 299 | 242 |
| MobileNetV2       | 213 | 180 |

(1) Archlinux tensorflow-opt-cuda 1.14.0-2 package
{'ResNet50': 107.19068351196866, 'InceptionV3': 61.418491801638766, 'InceptionResNetV2': 26.594283654363345, 'VGG16': 108.32927954320353, 'Xception': 97.11161227265951, 'MobileNet': 310.4336555261628, 'MobileNetV2': 166.43469824511342}

(2) tensorflow/tensorflow:1.14.0-gpu-py3
{'ResNet50': 100.92651234419365, 'InceptionV3': 55.549074197116425, 'InceptionResNetV2': 24.134014089405998, 'VGG16': 100.65803916217949, 'Xception': 86.27741860927367, 'MobileNet': 238.66881065532527, 'MobileNetV2': 146.2111707725757}

(3) netmist/tensorflow:1.14.0-avx2-fma
{'ResNet50': 76.79335907148457, 'InceptionV3': 54.853590647942724, 'InceptionResNetV2': 24.895263949726772, 'VGG16': 104.01003507931156, 'Xception': 84.88294917001669, 'MobileNet': 245.0788370192134, 'MobileNetV2': 178.40314316533113}

() netmist/tensorflow:1.14.0-avx2-fma CPU
{'ResNet50': 28.664484756860293, 'InceptionV3': 25.882586692677776, 'InceptionResNetV2': 10.363975428397882, 'VGG16': 12.330643520608561, 'Xception': 15.04870181871762, 'MobileNet': 68.19926760699245, 'MobileNetV2': 51.864006793435976}

() tensorflow/tensorflow:1.14.0-gpu-py3 CPU
{'ResNet50': 28.19037078163618, 'InceptionV3': 25.45682005191842, 'InceptionResNetV2': 10.160676573741972, 'VGG16': 12.304525430215644, 'Xception': 14.983201523795456, 'MobileNet': 69.77397260914091, 'MobileNetV2': 53.335922690763766}

