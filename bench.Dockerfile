ARG     BASE_IMAGE=tensorflow/tensorflow:1.14.0-gpu-py3
FROM    ${BASE_IMAGE} 
WORKDIR /bench
RUN     pip install coloredlogs requests tqdm Pillow
CMD     python3 keras.py
