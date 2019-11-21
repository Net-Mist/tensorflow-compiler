ARG     BASE_IMAGE=tensorflow/tensorflow:2.0.0-gpu-py3
FROM    ${BASE_IMAGE} 
WORKDIR /bench
RUN     pip install coloredlogs requests tqdm Pillow
CMD     python keras.py
