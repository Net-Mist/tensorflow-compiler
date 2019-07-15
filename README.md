# tensorflow-compiler
Code to compile tensorflow inside docker.
The structure of the project is explained in [this article](https://net-mist.github.io/tfcompile)


tensorflow/tensorflow:1.14.0-gpu-py3
docker run -it --rm --runtime=nvidia tensorflow/tensorflow:1.14.0-gpu-py3 bash
When open a tensorflow session:
Your CPU supports instructions that this TensorFlow binary was not compiled to use: AVX2 AVX512F FMA


TODO
  - update to ubuntu 19.04 with python 3.7 support
  - check option --gpu when building pip package
  - check proco extention on P100 server
  
This stackoferflow is quite complete :https://stackoverflow.com/questions/41293077/how-to-compile-tensorflow-with-sse4-2-and-avx-instructions