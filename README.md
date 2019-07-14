# tensorflow-compiler
Code to compile tensorflow inside docker.
The structure of the project is explained in [this article](https://net-mist.github.io/tfcompile)


tensorflow/tensorflow:1.14.0-gpu-py3
docker run -it --rm --runtime=nvidia tensorflow/tensorflow:1.14.0-gpu-py3 bash
When open a tensorflow session:
Your CPU supports instructions that this TensorFlow binary was not compiled to use: AVX2 AVX512F FMA


