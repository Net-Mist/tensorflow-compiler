#!/bin/bash

apt update
apt install git
pip3 install -y psutil requests google-auth google-cloud google-api-python-client pyyaml \
                google-cloud google-cloud-bigquery mock absl-py wheel tfds-nightly scikit-learn
python3 lib/benchmark.py --git_repos="https://github.com/tensorflow/models.git" \
                        --python_path=models --gcloud_key_file_url="" \
                        --benchmark_methods=official.resnet.keras.keras_cifar_benchmark.Resnet56KerasBenchmarkSynth.benchmark_1_gpu_no_dist_strat

python3 lib/benchmark.py --git_repos="https://github.com/tensorflow/models.git" \
                        --python_path=models --gcloud_key_file_url=""  \
                        --benchmark_methods=official.resnet.keras.keras_cifar_benchmark.Resnet56KerasBenchmarkSynth.benchmark_1_gpu_no_dist_strat,official.resnet.estimator_benchmark.Resnet50EstimatorBenchmarkSynth.benchmark_graph_1_gpu

