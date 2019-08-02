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
  
# Sources:
This stackoverflow is quite complete :https://stackoverflow.com/questions/41293077/how-to-compile-tensorflow-with-sse4-2-and-avx-instructions
add -nogcp and implement https://github.com/tensorflow/tensorflow/issues/29617

  - Archlinux wiki: https://git.archlinux.org/svntogit/community.git/plain/trunk/PKGBUILD?h=packages/tensorflow
  - https://github.com/tensorflow/benchmarks/issues/272

# Benchmark

To build the benchmark image run:
```bash
export BASE_IMAGE=netmist/tensorflow:1.14.0-avx2-fma
make build_bench
make bench
```

Size:
netmist/tensorflow:1.14.0-avx2-avx512f-fma-6.0 | 3.05 GB 
netmist/tensorflow:1.14.0-avx2-fma             | 2.87 GB
netmist/tensorflow:1.14.0-avx2-avx512f-fma     | 2.87 GB
netmist/tensorflow:1.14.0-opt                  | 2.84 GB (5d4776b5e31f)
tensorflow/tensorflow:1.14.0-gpu-py3           | 3.51 GB


docker run -it --rm tensorflow/tensorflow:1.14.0-py3 bash

## FPS on a computer with Quadro P4000 + I7-7700

| Models            | (1) | (2) |
|-------------------|:---:|:---:|

(1) Archlinux tensorflow-opt-cuda 1.14.0-2 package
{'ResNet50': 59.00547387508943, 'InceptionV3': 50.11413912228413, 'InceptionResNetV2': 22.4256804950923, 'VGG16': 78.34706569774471, 'Xception': 67.60028923972799, 'MobileNet': 233.54856905827435, 'MobileNetV2': 172.1870355925941}
{'ResNet50': 88.07301159622031, 'InceptionV3': 48.50076903667859, 'InceptionResNetV2': 22.959722313199688, 'VGG16': 81.55460786644109, 'Xception': 70.9670068571031, 'MobileNet': 237.47072497032357, 'MobileNetV2': 164.35512462471254}


(2) tensorflow/tensorflow:1.14.0-gpu-py3
{'ResNet50': 78.27896643000801, 'InceptionV3': 46.06719815026825, 'InceptionResNetV2': 21.30824777529307, 'VGG16': 80.59807692390736, 'Xception': 68.6390868349327, 'MobileNet': 195.39085493071426, 'MobileNetV2': 142.89577218935477}

(3) netmist/tensorflow:1.14.0-avx2-fma
{'ResNet50': 79.96613982574212, 'InceptionV3': 46.01720703271388, 'InceptionResNetV2': 21.32257584706408, 'VGG16': 80.31664582153107, 'Xception': 59.438597496876746, 'MobileNet': 198.77540570532767, 'MobileNetV2': 146.0054679732437}




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


## FPS on sake

() netmist/tensorflow:1.14.0-avx2-fma
{'ResNet50': 28.677391170809884, 'InceptionV3': 28.563387605799555, 'InceptionResNetV2': 17.47985183665245, 'VGG16': 118.71391481442377, 'Xception': 48.97231091029714, 'MobileNet': 74.34725974563722, 'MobileNetV2': 60.20276047612835}

() tensorflow opt
{'ResNet50': 45.973262994183585, 'InceptionV3': 28.91931670432652, 'InceptionResNetV2': 16.844592097207876, 'VGG16': 107.47751538917777, 'Xception': 49.54199096946707, 'MobileNet': 73.67637253661634, 'MobileNetV2': 49.280450584571014}


() tensorflow opt cpu
{'ResNet50': 12.118044610491111, 'InceptionV3': 9.693851314381368, 'InceptionResNetV2': 3.9092108732497577, 'VGG16': 8.75470086696838, 'Xception': 9.844244851941703, 'MobileNet': 26.54544443468636, 'MobileNetV2': 18.246935736010172}


() tensorflow official
{'ResNet50': 28.86801080316275, 'InceptionV3': 28.343874925029322, 'InceptionResNetV2': 18.022793536682958, 'VGG16': 121.0920663919959, 'Xception': 49.59775064104259, 'MobileNet': 74.44076773729358, 'MobileNetV2': 48.135939556743956}


() tensorflow official cpu
{'ResNet50': 13.173113207563816, 'InceptionV3': 11.318125467681043, 'InceptionResNetV2': 4.660459205722376, 'VGG16': 8.022583315153415, 'Xception': 9.082312586168614, 'MobileNet': 27.96209788099835, 'MobileNetV2': 18.748385903703827}



# Archlinux opt package
{'ResNet50': 71.20137163897239, 'InceptionV3': 61.76223628126513, 'InceptionResNetV2': 25.53762950428918, 'VGG16': 106.43553672963958, 'Xception': 92.22267855413496, 'MobileNet': 304.0278997414127, 'MobileNetV2': 230.6046092127421}

# Non opt
{'ResNet50': 74.5042235479639, 'InceptionV3': 61.52620054552158, 'InceptionResNetV2': 26.44218531407851, 'VGG16': 107.14923930661986, 'Xception': 93.06361650993728, 'MobileNet': 305.9586042520267, 'MobileNetV2': 243.7160540899096}


# Anaconda install
See https://www.digitalocean.com/community/tutorials/how-to-install-the-anaconda-python-distribution-on-ubuntu-18-04
  added / updated specs:
    - _ipyw_jlab_nb_ext_conf==0.1.0=py37_0
    - _libgcc_mutex==0.1=main
    - alabaster==0.7.12=py37_0
    - anaconda-client==1.7.2=py37_0
    - anaconda-navigator==1.9.7=py37_0
    - anaconda-project==0.8.3=py_0
    - anaconda==2019.07=py37_0
    - asn1crypto==0.24.0=py37_0
    - astroid==2.2.5=py37_0
    - astropy==3.2.1=py37h7b6447c_0
    - atomicwrites==1.3.0=py37_1
    - attrs==19.1.0=py37_1
    - babel==2.7.0=py_0
    - backcall==0.1.0=py37_0
    - backports.functools_lru_cache==1.5=py_2
    - backports.os==0.1.1=py37_0
    - backports.shutil_get_terminal_size==1.0.0=py37_2
    - backports.tempfile==1.0=py_1
    - backports.weakref==1.0.post1=py_1
    - backports==1.0=py_2
    - beautifulsoup4==4.7.1=py37_1
    - bitarray==0.9.3=py37h7b6447c_0
    - bkcharts==0.2=py37_0
    - blas==1.0=mkl
    - bleach==3.1.0=py37_0
    - blosc==1.16.3=hd408876_0
    - bokeh==1.2.0=py37_0
    - boto==2.49.0=py37_0
    - bottleneck==1.2.1=py37h035aef0_1
    - bzip2==1.0.8=h7b6447c_0
    - ca-certificates==2019.5.15=0
    - cairo==1.14.12=h8948797_3
    - certifi==2019.6.16=py37_0
    - cffi==1.12.3=py37h2e261b9_0
    - chardet==3.0.4=py37_1
    - click==7.0=py37_0
    - cloudpickle==1.2.1=py_0
    - clyent==1.2.2=py37_1
    - colorama==0.4.1=py37_0
    - conda-build==3.18.8=py37_0
    - conda-env==2.6.0=1
    - conda-package-handling==1.3.11=py37_0
    - conda-verify==3.4.2=py_1
    - conda==4.7.10=py37_0
    - contextlib2==0.5.5=py37_0
    - cryptography==2.7=py37h1ba5d50_0
    - curl==7.65.2=hbc83047_0
    - cycler==0.10.0=py37_0
    - cython==0.29.12=py37he6710b0_0
    - cytoolz==0.10.0=py37h7b6447c_0
    - dask-core==2.1.0=py_0
    - dask==2.1.0=py_0
    - dbus==1.13.6=h746ee38_0
    - decorator==4.4.0=py37_1
    - defusedxml==0.6.0=py_0
    - distributed==2.1.0=py_0
    - docutils==0.14=py37_0
    - entrypoints==0.3=py37_0
    - et_xmlfile==1.0.1=py37_0
    - expat==2.2.6=he6710b0_0
    - fastcache==1.1.0=py37h7b6447c_0
    - filelock==3.0.12=py_0
    - flask==1.1.1=py_0
    - fontconfig==2.13.0=h9420a91_0
    - freetype==2.9.1=h8a8886c_1
    - fribidi==1.0.5=h7b6447c_0
    - future==0.17.1=py37_0
    - get_terminal_size==1.0.0=haa9412d_0
    - gevent==1.4.0=py37h7b6447c_0
    - glib==2.56.2=hd408876_0
    - glob2==0.7=py_0
    - gmp==6.1.2=h6c8ec71_1
    - gmpy2==2.0.8=py37h10f8cd9_2
    - graphite2==1.3.13=h23475e2_0
    - greenlet==0.4.15=py37h7b6447c_0
    - gst-plugins-base==1.14.0=hbbd80ab_1
    - gstreamer==1.14.0=hb453b48_1
    - h5py==2.9.0=py37h7918eee_0
    - harfbuzz==1.8.8=hffaf4a1_0
    - hdf5==1.10.4=hb1b8bf9_0
    - heapdict==1.0.0=py37_2
    - html5lib==1.0.1=py37_0
    - icu==58.2=h9c2bf20_1
    - idna==2.8=py37_0
    - imageio==2.5.0=py37_0
    - imagesize==1.1.0=py37_0
    - importlib_metadata==0.17=py37_1
    - intel-openmp==2019.4=243
    - ipykernel==5.1.1=py37h39e3cac_0
    - ipython==7.6.1=py37h39e3cac_0
    - ipython_genutils==0.2.0=py37_0
    - ipywidgets==7.5.0=py_0
    - isort==4.3.21=py37_0
    - itsdangerous==1.1.0=py37_0
    - jbig==2.1=hdba287a_0
    - jdcal==1.4.1=py_0
    - jedi==0.13.3=py37_0
    - jeepney==0.4=py37_0
    - jinja2==2.10.1=py37_0
    - joblib==0.13.2=py37_0
    - jpeg==9b=h024ee3a_2
    - json5==0.8.4=py_0
    - jsonschema==3.0.1=py37_0
    - jupyter==1.0.0=py37_7
    - jupyter_client==5.3.1=py_0
    - jupyter_console==6.0.0=py37_0
    - jupyter_core==4.5.0=py_0
    - jupyterlab==1.0.2=py37hf63ae98_0
    - jupyterlab_server==1.0.0=py_0
    - keyring==18.0.0=py37_0
    - kiwisolver==1.1.0=py37he6710b0_0
    - krb5==1.16.1=h173b8e3_7
    - lazy-object-proxy==1.4.1=py37h7b6447c_0
    - libarchive==3.3.3=h5d8350f_5
    - libcurl==7.65.2=h20c2e04_0
    - libedit==3.1.20181209=hc058e9b_0
    - libffi==3.2.1=hd88cf55_4
    - libgcc-ng==9.1.0=hdf63c60_0
    - libgfortran-ng==7.3.0=hdf63c60_0
    - liblief==0.9.0=h7725739_2
    - libpng==1.6.37=hbc83047_0
    - libsodium==1.0.16=h1bed415_0
    - libssh2==1.8.2=h1ba5d50_0
    - libstdcxx-ng==9.1.0=hdf63c60_0
    - libtiff==4.0.10=h2733197_2
    - libtool==2.4.6=h7b6447c_5
    - libuuid==1.0.3=h1bed415_2
    - libxcb==1.13=h1bed415_1
    - libxml2==2.9.9=hea5a465_1
    - libxslt==1.1.33=h7d1a2b0_0
    - llvmlite==0.29.0=py37hd408876_0
    - locket==0.2.0=py37_1
    - lxml==4.3.4=py37hefd8a0e_0
    - lz4-c==1.8.1.2=h14c3975_0
    - lzo==2.10=h49e0be7_2
    - markupsafe==1.1.1=py37h7b6447c_0
    - matplotlib==3.1.0=py37h5429711_0
    - mccabe==0.6.1=py37_1
    - mistune==0.8.4=py37h7b6447c_0
    - mkl-service==2.0.2=py37h7b6447c_0
    - mkl==2019.4=243
    - mkl_fft==1.0.12=py37ha843d7b_0
    - mkl_random==1.0.2=py37hd81dba3_0
    - mock==3.0.5=py37_0
    - more-itertools==7.0.0=py37_0
    - mpc==1.1.0=h10f8cd9_1
    - mpfr==4.0.1=hdf1c602_3
    - mpmath==1.1.0=py37_0
    - msgpack-python==0.6.1=py37hfd86e86_1
    - multipledispatch==0.6.0=py37_0
    - navigator-updater==0.2.1=py37_0
    - nbconvert==5.5.0=py_0
    - nbformat==4.4.0=py37_0
    - ncurses==6.1=he6710b0_1
    - networkx==2.3=py_0
    - nltk==3.4.4=py37_0
    - nose==1.3.7=py37_2
    - notebook==6.0.0=py37_0
    - numba==0.44.1=py37h962f231_0
    - numexpr==2.6.9=py37h9e4a6bb_0
    - numpy-base==1.16.4=py37hde5b4d6_0
    - numpy==1.16.4=py37h7e9f1db_0
    - numpydoc==0.9.1=py_0
    - olefile==0.46=py37_0
    - openpyxl==2.6.2=py_0
    - openssl==1.1.1c=h7b6447c_1
    - packaging==19.0=py37_0
    - pandas==0.24.2=py37he6710b0_0
    - pandoc==2.2.3.2=0
    - pandocfilters==1.4.2=py37_1
    - pango==1.42.4=h049681c_0
    - parso==0.5.0=py_0
    - partd==1.0.0=py_0
    - patchelf==0.9=he6710b0_3
    - path.py==12.0.1=py_0
    - pathlib2==2.3.4=py37_0
    - patsy==0.5.1=py37_0
    - pcre==8.43=he6710b0_0
    - pep8==1.7.1=py37_0
    - pexpect==4.7.0=py37_0
    - pickleshare==0.7.5=py37_0
    - pillow==6.1.0=py37h34e0f95_0
    - pip==19.1.1=py37_0
    - pixman==0.38.0=h7b6447c_0
    - pkginfo==1.5.0.1=py37_0
    - pluggy==0.12.0=py_0
    - ply==3.11=py37_0
    - prometheus_client==0.7.1=py_0
    - prompt_toolkit==2.0.9=py37_0
    - psutil==5.6.3=py37h7b6447c_0
    - ptyprocess==0.6.0=py37_0
    - py-lief==0.9.0=py37h7725739_2
    - py==1.8.0=py37_0
    - pycodestyle==2.5.0=py37_0
    - pycosat==0.6.3=py37h14c3975_0
    - pycparser==2.19=py37_0
    - pycrypto==2.6.1=py37h14c3975_9
    - pycurl==7.43.0.3=py37h1ba5d50_0
    - pyflakes==2.1.1=py37_0
    - pygments==2.4.2=py_0
    - pylint==2.3.1=py37_0
    - pyodbc==4.0.26=py37he6710b0_0
    - pyopenssl==19.0.0=py37_0
    - pyparsing==2.4.0=py_0
    - pyqt==5.9.2=py37h05f1152_2
    - pyrsistent==0.14.11=py37h7b6447c_0
    - pysocks==1.7.0=py37_0
    - pytables==3.5.2=py37h71ec239_1
    - pytest-arraydiff==0.3=py37h39e3cac_0
    - pytest-astropy==0.5.0=py37_0
    - pytest-doctestplus==0.3.0=py37_0
    - pytest-openfiles==0.3.2=py37_0
    - pytest-remotedata==0.3.1=py37_0
    - pytest==5.0.1=py37_0
    - python-dateutil==2.8.0=py37_0
    - python-libarchive-c==2.8=py37_11
    - python==3.7.3=h0371630_0
    - pytz==2019.1=py_0
    - pywavelets==1.0.3=py37hdd07704_1
    - pyyaml==5.1.1=py37h7b6447c_0
    - pyzmq==18.0.0=py37he6710b0_0
    - qt==5.9.7=h5867ecd_1
    - qtawesome==0.5.7=py37_1
    - qtconsole==4.5.1=py_0
    - qtpy==1.8.0=py_0
    - readline==7.0=h7b6447c_5
    - requests==2.22.0=py37_0
    - rope==0.14.0=py_0
    - ruamel_yaml==0.15.46=py37h14c3975_0
    - scikit-image==0.15.0=py37he6710b0_0
    - scikit-learn==0.21.2=py37hd81dba3_0
    - scipy==1.3.0=py37h7c811a0_0
    - seaborn==0.9.0=py37_0
    - secretstorage==3.1.1=py37_0
    - send2trash==1.5.0=py37_0
    - setuptools==41.0.1=py37_0
    - simplegeneric==0.8.1=py37_2
    - singledispatch==3.4.0.3=py37_0
    - sip==4.19.8=py37hf484d3e_0
    - six==1.12.0=py37_0
    - snappy==1.1.7=hbae5bb6_3
    - snowballstemmer==1.9.0=py_0
    - sortedcollections==1.1.2=py37_0
    - sortedcontainers==2.1.0=py37_0
    - soupsieve==1.8=py37_0
    - sphinx==2.1.2=py_0
    - sphinxcontrib-applehelp==1.0.1=py_0
    - sphinxcontrib-devhelp==1.0.1=py_0
    - sphinxcontrib-htmlhelp==1.0.2=py_0
    - sphinxcontrib-jsmath==1.0.1=py_0
    - sphinxcontrib-qthelp==1.0.2=py_0
    - sphinxcontrib-serializinghtml==1.1.3=py_0
    - sphinxcontrib-websupport==1.1.2=py_0
    - sphinxcontrib==1.0=py37_1
    - spyder-kernels==0.5.1=py37_0
    - spyder==3.3.6=py37_0
    - sqlalchemy==1.3.5=py37h7b6447c_0
    - sqlite==3.29.0=h7b6447c_0
    - statsmodels==0.10.0=py37hdd07704_0
    - sympy==1.4=py37_0
    - tblib==1.4.0=py_0
    - terminado==0.8.2=py37_0
    - testpath==0.4.2=py37_0
    - tk==8.6.8=hbc83047_0
    - toolz==0.10.0=py_0
    - tornado==6.0.3=py37h7b6447c_0
    - tqdm==4.32.1=py_0
    - traitlets==4.3.2=py37_0
    - unicodecsv==0.14.1=py37_0
    - unixodbc==2.3.7=h14c3975_0
    - urllib3==1.24.2=py37_0
    - wcwidth==0.1.7=py37_0
    - webencodings==0.5.1=py37_1
    - werkzeug==0.15.4=py_0
    - wheel==0.33.4=py37_0
    - widgetsnbextension==3.5.0=py37_0
    - wrapt==1.11.2=py37h7b6447c_0
    - wurlitzer==1.0.2=py37_0
    - xlrd==1.2.0=py37_0
    - xlsxwriter==1.1.8=py_0
    - xlwt==1.3.0=py37_0
    - xz==5.2.4=h14c3975_4
    - yaml==0.1.7=had09818_2
    - zeromq==4.3.1=he6710b0_3
    - zict==1.0.0=py_0
    - zipp==0.5.1=py_0
    - zlib==1.2.11=h7b6447c_3
    - zstd==1.3.7=h0b5b093_0

The following NEW packages will be INSTALLED:

  _ipyw_jlab_nb_ext~ pkgs/main/linux-64::_ipyw_jlab_nb_ext_conf-0.1.0-py37_0
  _libgcc_mutex      pkgs/main/linux-64::_libgcc_mutex-0.1-main
  alabaster          pkgs/main/linux-64::alabaster-0.7.12-py37_0
  anaconda           pkgs/main/linux-64::anaconda-2019.07-py37_0
  anaconda-client    pkgs/main/linux-64::anaconda-client-1.7.2-py37_0
  anaconda-navigator pkgs/main/linux-64::anaconda-navigator-1.9.7-py37_0
  anaconda-project   pkgs/main/noarch::anaconda-project-0.8.3-py_0
  asn1crypto         pkgs/main/linux-64::asn1crypto-0.24.0-py37_0
  astroid            pkgs/main/linux-64::astroid-2.2.5-py37_0
  astropy            pkgs/main/linux-64::astropy-3.2.1-py37h7b6447c_0
  atomicwrites       pkgs/main/linux-64::atomicwrites-1.3.0-py37_1
  attrs              pkgs/main/linux-64::attrs-19.1.0-py37_1
  babel              pkgs/main/noarch::babel-2.7.0-py_0
  backcall           pkgs/main/linux-64::backcall-0.1.0-py37_0
  backports          pkgs/main/noarch::backports-1.0-py_2
  backports.functoo~ pkgs/main/noarch::backports.functools_lru_cache-1.5-py_2
  backports.os       pkgs/main/linux-64::backports.os-0.1.1-py37_0
  backports.shutil_~ pkgs/main/linux-64::backports.shutil_get_terminal_size-1.0.0-py37_2
  backports.tempfile pkgs/main/noarch::backports.tempfile-1.0-py_1
  backports.weakref  pkgs/main/noarch::backports.weakref-1.0.post1-py_1
  beautifulsoup4     pkgs/main/linux-64::beautifulsoup4-4.7.1-py37_1
  bitarray           pkgs/main/linux-64::bitarray-0.9.3-py37h7b6447c_0
  bkcharts           pkgs/main/linux-64::bkcharts-0.2-py37_0
  blas               pkgs/main/linux-64::blas-1.0-mkl
  bleach             pkgs/main/linux-64::bleach-3.1.0-py37_0
  blosc              pkgs/main/linux-64::blosc-1.16.3-hd408876_0
  bokeh              pkgs/main/linux-64::bokeh-1.2.0-py37_0
  boto               pkgs/main/linux-64::boto-2.49.0-py37_0
  bottleneck         pkgs/main/linux-64::bottleneck-1.2.1-py37h035aef0_1
  bzip2              pkgs/main/linux-64::bzip2-1.0.8-h7b6447c_0
  ca-certificates    pkgs/main/linux-64::ca-certificates-2019.5.15-0
  cairo              pkgs/main/linux-64::cairo-1.14.12-h8948797_3
  certifi            pkgs/main/linux-64::certifi-2019.6.16-py37_0
  cffi               pkgs/main/linux-64::cffi-1.12.3-py37h2e261b9_0
  chardet            pkgs/main/linux-64::chardet-3.0.4-py37_1
  click              pkgs/main/linux-64::click-7.0-py37_0
  cloudpickle        pkgs/main/noarch::cloudpickle-1.2.1-py_0
  clyent             pkgs/main/linux-64::clyent-1.2.2-py37_1
  colorama           pkgs/main/linux-64::colorama-0.4.1-py37_0
  conda              pkgs/main/linux-64::conda-4.7.10-py37_0
  conda-build        pkgs/main/linux-64::conda-build-3.18.8-py37_0
  conda-env          pkgs/main/linux-64::conda-env-2.6.0-1
  conda-package-han~ pkgs/main/linux-64::conda-package-handling-1.3.11-py37_0
  conda-verify       pkgs/main/noarch::conda-verify-3.4.2-py_1
  contextlib2        pkgs/main/linux-64::contextlib2-0.5.5-py37_0
  cryptography       pkgs/main/linux-64::cryptography-2.7-py37h1ba5d50_0
  curl               pkgs/main/linux-64::curl-7.65.2-hbc83047_0
  cycler             pkgs/main/linux-64::cycler-0.10.0-py37_0
  cython             pkgs/main/linux-64::cython-0.29.12-py37he6710b0_0
  cytoolz            pkgs/main/linux-64::cytoolz-0.10.0-py37h7b6447c_0
  dask               pkgs/main/noarch::dask-2.1.0-py_0
  dask-core          pkgs/main/noarch::dask-core-2.1.0-py_0
  dbus               pkgs/main/linux-64::dbus-1.13.6-h746ee38_0
  decorator          pkgs/main/linux-64::decorator-4.4.0-py37_1
  defusedxml         pkgs/main/noarch::defusedxml-0.6.0-py_0
  distributed        pkgs/main/noarch::distributed-2.1.0-py_0
  docutils           pkgs/main/linux-64::docutils-0.14-py37_0
  entrypoints        pkgs/main/linux-64::entrypoints-0.3-py37_0
  et_xmlfile         pkgs/main/linux-64::et_xmlfile-1.0.1-py37_0
  expat              pkgs/main/linux-64::expat-2.2.6-he6710b0_0
  fastcache          pkgs/main/linux-64::fastcache-1.1.0-py37h7b6447c_0
  filelock           pkgs/main/noarch::filelock-3.0.12-py_0
  flask              pkgs/main/noarch::flask-1.1.1-py_0
  fontconfig         pkgs/main/linux-64::fontconfig-2.13.0-h9420a91_0
  freetype           pkgs/main/linux-64::freetype-2.9.1-h8a8886c_1
  fribidi            pkgs/main/linux-64::fribidi-1.0.5-h7b6447c_0
  future             pkgs/main/linux-64::future-0.17.1-py37_0
  get_terminal_size  pkgs/main/linux-64::get_terminal_size-1.0.0-haa9412d_0
  gevent             pkgs/main/linux-64::gevent-1.4.0-py37h7b6447c_0
  glib               pkgs/main/linux-64::glib-2.56.2-hd408876_0
  glob2              pkgs/main/noarch::glob2-0.7-py_0
  gmp                pkgs/main/linux-64::gmp-6.1.2-h6c8ec71_1
  gmpy2              pkgs/main/linux-64::gmpy2-2.0.8-py37h10f8cd9_2
  graphite2          pkgs/main/linux-64::graphite2-1.3.13-h23475e2_0
  greenlet           pkgs/main/linux-64::greenlet-0.4.15-py37h7b6447c_0
  gst-plugins-base   pkgs/main/linux-64::gst-plugins-base-1.14.0-hbbd80ab_1
  gstreamer          pkgs/main/linux-64::gstreamer-1.14.0-hb453b48_1
  h5py               pkgs/main/linux-64::h5py-2.9.0-py37h7918eee_0
  harfbuzz           pkgs/main/linux-64::harfbuzz-1.8.8-hffaf4a1_0
  hdf5               pkgs/main/linux-64::hdf5-1.10.4-hb1b8bf9_0
  heapdict           pkgs/main/linux-64::heapdict-1.0.0-py37_2
  html5lib           pkgs/main/linux-64::html5lib-1.0.1-py37_0
  icu                pkgs/main/linux-64::icu-58.2-h9c2bf20_1
  idna               pkgs/main/linux-64::idna-2.8-py37_0
  imageio            pkgs/main/linux-64::imageio-2.5.0-py37_0
  imagesize          pkgs/main/linux-64::imagesize-1.1.0-py37_0
  importlib_metadata pkgs/main/linux-64::importlib_metadata-0.17-py37_1
  intel-openmp       pkgs/main/linux-64::intel-openmp-2019.4-243
  ipykernel          pkgs/main/linux-64::ipykernel-5.1.1-py37h39e3cac_0
  ipython            pkgs/main/linux-64::ipython-7.6.1-py37h39e3cac_0
  ipython_genutils   pkgs/main/linux-64::ipython_genutils-0.2.0-py37_0
  ipywidgets         pkgs/main/noarch::ipywidgets-7.5.0-py_0
  isort              pkgs/main/linux-64::isort-4.3.21-py37_0
  itsdangerous       pkgs/main/linux-64::itsdangerous-1.1.0-py37_0
  jbig               pkgs/main/linux-64::jbig-2.1-hdba287a_0
  jdcal              pkgs/main/noarch::jdcal-1.4.1-py_0
  jedi               pkgs/main/linux-64::jedi-0.13.3-py37_0
  jeepney            pkgs/main/linux-64::jeepney-0.4-py37_0
  jinja2             pkgs/main/linux-64::jinja2-2.10.1-py37_0
  joblib             pkgs/main/linux-64::joblib-0.13.2-py37_0
  jpeg               pkgs/main/linux-64::jpeg-9b-h024ee3a_2
  json5              pkgs/main/noarch::json5-0.8.4-py_0
  jsonschema         pkgs/main/linux-64::jsonschema-3.0.1-py37_0
  jupyter            pkgs/main/linux-64::jupyter-1.0.0-py37_7
  jupyter_client     pkgs/main/noarch::jupyter_client-5.3.1-py_0
  jupyter_console    pkgs/main/linux-64::jupyter_console-6.0.0-py37_0
  jupyter_core       pkgs/main/noarch::jupyter_core-4.5.0-py_0
  jupyterlab         pkgs/main/linux-64::jupyterlab-1.0.2-py37hf63ae98_0
  jupyterlab_server  pkgs/main/noarch::jupyterlab_server-1.0.0-py_0
  keyring            pkgs/main/linux-64::keyring-18.0.0-py37_0
  kiwisolver         pkgs/main/linux-64::kiwisolver-1.1.0-py37he6710b0_0
  krb5               pkgs/main/linux-64::krb5-1.16.1-h173b8e3_7
  lazy-object-proxy  pkgs/main/linux-64::lazy-object-proxy-1.4.1-py37h7b6447c_0
  libarchive         pkgs/main/linux-64::libarchive-3.3.3-h5d8350f_5
  libcurl            pkgs/main/linux-64::libcurl-7.65.2-h20c2e04_0
  libedit            pkgs/main/linux-64::libedit-3.1.20181209-hc058e9b_0
  libffi             pkgs/main/linux-64::libffi-3.2.1-hd88cf55_4
  libgcc-ng          pkgs/main/linux-64::libgcc-ng-9.1.0-hdf63c60_0
  libgfortran-ng     pkgs/main/linux-64::libgfortran-ng-7.3.0-hdf63c60_0
  liblief            pkgs/main/linux-64::liblief-0.9.0-h7725739_2
  libpng             pkgs/main/linux-64::libpng-1.6.37-hbc83047_0
  libsodium          pkgs/main/linux-64::libsodium-1.0.16-h1bed415_0
  libssh2            pkgs/main/linux-64::libssh2-1.8.2-h1ba5d50_0
  libstdcxx-ng       pkgs/main/linux-64::libstdcxx-ng-9.1.0-hdf63c60_0
  libtiff            pkgs/main/linux-64::libtiff-4.0.10-h2733197_2
  libtool            pkgs/main/linux-64::libtool-2.4.6-h7b6447c_5
  libuuid            pkgs/main/linux-64::libuuid-1.0.3-h1bed415_2
  libxcb             pkgs/main/linux-64::libxcb-1.13-h1bed415_1
  libxml2            pkgs/main/linux-64::libxml2-2.9.9-hea5a465_1
  libxslt            pkgs/main/linux-64::libxslt-1.1.33-h7d1a2b0_0
  llvmlite           pkgs/main/linux-64::llvmlite-0.29.0-py37hd408876_0
  locket             pkgs/main/linux-64::locket-0.2.0-py37_1
  lxml               pkgs/main/linux-64::lxml-4.3.4-py37hefd8a0e_0
  lz4-c              pkgs/main/linux-64::lz4-c-1.8.1.2-h14c3975_0
  lzo                pkgs/main/linux-64::lzo-2.10-h49e0be7_2
  markupsafe         pkgs/main/linux-64::markupsafe-1.1.1-py37h7b6447c_0
  matplotlib         pkgs/main/linux-64::matplotlib-3.1.0-py37h5429711_0
  mccabe             pkgs/main/linux-64::mccabe-0.6.1-py37_1
  mistune            pkgs/main/linux-64::mistune-0.8.4-py37h7b6447c_0
  mkl                pkgs/main/linux-64::mkl-2019.4-243
  mkl-service        pkgs/main/linux-64::mkl-service-2.0.2-py37h7b6447c_0
  mkl_fft            pkgs/main/linux-64::mkl_fft-1.0.12-py37ha843d7b_0
  mkl_random         pkgs/main/linux-64::mkl_random-1.0.2-py37hd81dba3_0
  mock               pkgs/main/linux-64::mock-3.0.5-py37_0
  more-itertools     pkgs/main/linux-64::more-itertools-7.0.0-py37_0
  mpc                pkgs/main/linux-64::mpc-1.1.0-h10f8cd9_1
  mpfr               pkgs/main/linux-64::mpfr-4.0.1-hdf1c602_3
  mpmath             pkgs/main/linux-64::mpmath-1.1.0-py37_0
  msgpack-python     pkgs/main/linux-64::msgpack-python-0.6.1-py37hfd86e86_1
  multipledispatch   pkgs/main/linux-64::multipledispatch-0.6.0-py37_0
  navigator-updater  pkgs/main/linux-64::navigator-updater-0.2.1-py37_0
  nbconvert          pkgs/main/noarch::nbconvert-5.5.0-py_0
  nbformat           pkgs/main/linux-64::nbformat-4.4.0-py37_0
  ncurses            pkgs/main/linux-64::ncurses-6.1-he6710b0_1
  networkx           pkgs/main/noarch::networkx-2.3-py_0
  nltk               pkgs/main/linux-64::nltk-3.4.4-py37_0
  nose               pkgs/main/linux-64::nose-1.3.7-py37_2
  notebook           pkgs/main/linux-64::notebook-6.0.0-py37_0
  numba              pkgs/main/linux-64::numba-0.44.1-py37h962f231_0
  numexpr            pkgs/main/linux-64::numexpr-2.6.9-py37h9e4a6bb_0
  numpy              pkgs/main/linux-64::numpy-1.16.4-py37h7e9f1db_0
  numpy-base         pkgs/main/linux-64::numpy-base-1.16.4-py37hde5b4d6_0
  numpydoc           pkgs/main/noarch::numpydoc-0.9.1-py_0
  olefile            pkgs/main/linux-64::olefile-0.46-py37_0
  openpyxl           pkgs/main/noarch::openpyxl-2.6.2-py_0
  openssl            pkgs/main/linux-64::openssl-1.1.1c-h7b6447c_1
  packaging          pkgs/main/linux-64::packaging-19.0-py37_0
  pandas             pkgs/main/linux-64::pandas-0.24.2-py37he6710b0_0
  pandoc             pkgs/main/linux-64::pandoc-2.2.3.2-0
  pandocfilters      pkgs/main/linux-64::pandocfilters-1.4.2-py37_1
  pango              pkgs/main/linux-64::pango-1.42.4-h049681c_0
  parso              pkgs/main/noarch::parso-0.5.0-py_0
  partd              pkgs/main/noarch::partd-1.0.0-py_0
  patchelf           pkgs/main/linux-64::patchelf-0.9-he6710b0_3
  path.py            pkgs/main/noarch::path.py-12.0.1-py_0
  pathlib2           pkgs/main/linux-64::pathlib2-2.3.4-py37_0
  patsy              pkgs/main/linux-64::patsy-0.5.1-py37_0
  pcre               pkgs/main/linux-64::pcre-8.43-he6710b0_0
  pep8               pkgs/main/linux-64::pep8-1.7.1-py37_0
  pexpect            pkgs/main/linux-64::pexpect-4.7.0-py37_0
  pickleshare        pkgs/main/linux-64::pickleshare-0.7.5-py37_0
  pillow             pkgs/main/linux-64::pillow-6.1.0-py37h34e0f95_0
  pip                pkgs/main/linux-64::pip-19.1.1-py37_0
  pixman             pkgs/main/linux-64::pixman-0.38.0-h7b6447c_0
  pkginfo            pkgs/main/linux-64::pkginfo-1.5.0.1-py37_0
  pluggy             pkgs/main/noarch::pluggy-0.12.0-py_0
  ply                pkgs/main/linux-64::ply-3.11-py37_0
  prometheus_client  pkgs/main/noarch::prometheus_client-0.7.1-py_0
  prompt_toolkit     pkgs/main/linux-64::prompt_toolkit-2.0.9-py37_0
  psutil             pkgs/main/linux-64::psutil-5.6.3-py37h7b6447c_0
  ptyprocess         pkgs/main/linux-64::ptyprocess-0.6.0-py37_0
  py                 pkgs/main/linux-64::py-1.8.0-py37_0
  py-lief            pkgs/main/linux-64::py-lief-0.9.0-py37h7725739_2
  pycodestyle        pkgs/main/linux-64::pycodestyle-2.5.0-py37_0
  pycosat            pkgs/main/linux-64::pycosat-0.6.3-py37h14c3975_0
  pycparser          pkgs/main/linux-64::pycparser-2.19-py37_0
  pycrypto           pkgs/main/linux-64::pycrypto-2.6.1-py37h14c3975_9
  pycurl             pkgs/main/linux-64::pycurl-7.43.0.3-py37h1ba5d50_0
  pyflakes           pkgs/main/linux-64::pyflakes-2.1.1-py37_0
  pygments           pkgs/main/noarch::pygments-2.4.2-py_0
  pylint             pkgs/main/linux-64::pylint-2.3.1-py37_0
  pyodbc             pkgs/main/linux-64::pyodbc-4.0.26-py37he6710b0_0
  pyopenssl          pkgs/main/linux-64::pyopenssl-19.0.0-py37_0
  pyparsing          pkgs/main/noarch::pyparsing-2.4.0-py_0
  pyqt               pkgs/main/linux-64::pyqt-5.9.2-py37h05f1152_2
  pyrsistent         pkgs/main/linux-64::pyrsistent-0.14.11-py37h7b6447c_0
  pysocks            pkgs/main/linux-64::pysocks-1.7.0-py37_0
  pytables           pkgs/main/linux-64::pytables-3.5.2-py37h71ec239_1
  pytest             pkgs/main/linux-64::pytest-5.0.1-py37_0
  pytest-arraydiff   pkgs/main/linux-64::pytest-arraydiff-0.3-py37h39e3cac_0
  pytest-astropy     pkgs/main/linux-64::pytest-astropy-0.5.0-py37_0
  pytest-doctestplus pkgs/main/linux-64::pytest-doctestplus-0.3.0-py37_0
  pytest-openfiles   pkgs/main/linux-64::pytest-openfiles-0.3.2-py37_0
  pytest-remotedata  pkgs/main/linux-64::pytest-remotedata-0.3.1-py37_0
  python             pkgs/main/linux-64::python-3.7.3-h0371630_0
  python-dateutil    pkgs/main/linux-64::python-dateutil-2.8.0-py37_0
  python-libarchive~ pkgs/main/linux-64::python-libarchive-c-2.8-py37_11
  pytz               pkgs/main/noarch::pytz-2019.1-py_0
  pywavelets         pkgs/main/linux-64::pywavelets-1.0.3-py37hdd07704_1
  pyyaml             pkgs/main/linux-64::pyyaml-5.1.1-py37h7b6447c_0
  pyzmq              pkgs/main/linux-64::pyzmq-18.0.0-py37he6710b0_0
  qt                 pkgs/main/linux-64::qt-5.9.7-h5867ecd_1
  qtawesome          pkgs/main/linux-64::qtawesome-0.5.7-py37_1
  qtconsole          pkgs/main/noarch::qtconsole-4.5.1-py_0
  qtpy               pkgs/main/noarch::qtpy-1.8.0-py_0
  readline           pkgs/main/linux-64::readline-7.0-h7b6447c_5
  requests           pkgs/main/linux-64::requests-2.22.0-py37_0
  rope               pkgs/main/noarch::rope-0.14.0-py_0
  ruamel_yaml        pkgs/main/linux-64::ruamel_yaml-0.15.46-py37h14c3975_0
  scikit-image       pkgs/main/linux-64::scikit-image-0.15.0-py37he6710b0_0
  scikit-learn       pkgs/main/linux-64::scikit-learn-0.21.2-py37hd81dba3_0
  scipy              pkgs/main/linux-64::scipy-1.3.0-py37h7c811a0_0
  seaborn            pkgs/main/linux-64::seaborn-0.9.0-py37_0
  secretstorage      pkgs/main/linux-64::secretstorage-3.1.1-py37_0
  send2trash         pkgs/main/linux-64::send2trash-1.5.0-py37_0
  setuptools         pkgs/main/linux-64::setuptools-41.0.1-py37_0
  simplegeneric      pkgs/main/linux-64::simplegeneric-0.8.1-py37_2
  singledispatch     pkgs/main/linux-64::singledispatch-3.4.0.3-py37_0
  sip                pkgs/main/linux-64::sip-4.19.8-py37hf484d3e_0
  six                pkgs/main/linux-64::six-1.12.0-py37_0
  snappy             pkgs/main/linux-64::snappy-1.1.7-hbae5bb6_3
  snowballstemmer    pkgs/main/noarch::snowballstemmer-1.9.0-py_0
  sortedcollections  pkgs/main/linux-64::sortedcollections-1.1.2-py37_0
  sortedcontainers   pkgs/main/linux-64::sortedcontainers-2.1.0-py37_0
  soupsieve          pkgs/main/linux-64::soupsieve-1.8-py37_0
  sphinx             pkgs/main/noarch::sphinx-2.1.2-py_0
  sphinxcontrib      pkgs/main/linux-64::sphinxcontrib-1.0-py37_1
  sphinxcontrib-app~ pkgs/main/noarch::sphinxcontrib-applehelp-1.0.1-py_0
  sphinxcontrib-dev~ pkgs/main/noarch::sphinxcontrib-devhelp-1.0.1-py_0
  sphinxcontrib-htm~ pkgs/main/noarch::sphinxcontrib-htmlhelp-1.0.2-py_0
  sphinxcontrib-jsm~ pkgs/main/noarch::sphinxcontrib-jsmath-1.0.1-py_0
  sphinxcontrib-qth~ pkgs/main/noarch::sphinxcontrib-qthelp-1.0.2-py_0
  sphinxcontrib-ser~ pkgs/main/noarch::sphinxcontrib-serializinghtml-1.1.3-py_0
  sphinxcontrib-web~ pkgs/main/noarch::sphinxcontrib-websupport-1.1.2-py_0
  spyder             pkgs/main/linux-64::spyder-3.3.6-py37_0
  spyder-kernels     pkgs/main/linux-64::spyder-kernels-0.5.1-py37_0
  sqlalchemy         pkgs/main/linux-64::sqlalchemy-1.3.5-py37h7b6447c_0
  sqlite             pkgs/main/linux-64::sqlite-3.29.0-h7b6447c_0
  statsmodels        pkgs/main/linux-64::statsmodels-0.10.0-py37hdd07704_0
  sympy              pkgs/main/linux-64::sympy-1.4-py37_0
  tblib              pkgs/main/noarch::tblib-1.4.0-py_0
  terminado          pkgs/main/linux-64::terminado-0.8.2-py37_0
  testpath           pkgs/main/linux-64::testpath-0.4.2-py37_0
  tk                 pkgs/main/linux-64::tk-8.6.8-hbc83047_0
  toolz              pkgs/main/noarch::toolz-0.10.0-py_0
  tornado            pkgs/main/linux-64::tornado-6.0.3-py37h7b6447c_0
  tqdm               pkgs/main/noarch::tqdm-4.32.1-py_0
  traitlets          pkgs/main/linux-64::traitlets-4.3.2-py37_0
  unicodecsv         pkgs/main/linux-64::unicodecsv-0.14.1-py37_0
  unixodbc           pkgs/main/linux-64::unixodbc-2.3.7-h14c3975_0
  urllib3            pkgs/main/linux-64::urllib3-1.24.2-py37_0
  wcwidth            pkgs/main/linux-64::wcwidth-0.1.7-py37_0
  webencodings       pkgs/main/linux-64::webencodings-0.5.1-py37_1
  werkzeug           pkgs/main/noarch::werkzeug-0.15.4-py_0
  wheel              pkgs/main/linux-64::wheel-0.33.4-py37_0
  widgetsnbextension pkgs/main/linux-64::widgetsnbextension-3.5.0-py37_0
  wrapt              pkgs/main/linux-64::wrapt-1.11.2-py37h7b6447c_0
  wurlitzer          pkgs/main/linux-64::wurlitzer-1.0.2-py37_0
  xlrd               pkgs/main/linux-64::xlrd-1.2.0-py37_0
  xlsxwriter         pkgs/main/noarch::xlsxwriter-1.1.8-py_0
  xlwt               pkgs/main/linux-64::xlwt-1.3.0-py37_0
  xz                 pkgs/main/linux-64::xz-5.2.4-h14c3975_4
  yaml               pkgs/main/linux-64::yaml-0.1.7-had09818_2
  zeromq             pkgs/main/linux-64::zeromq-4.3.1-he6710b0_3
  zict               pkgs/main/noarch::zict-1.0.0-py_0
  zipp               pkgs/main/noarch::zipp-0.5.1-py_0
  zlib               pkgs/main/linux-64::zlib-1.2.11-h7b6447c_3
  zstd               pkgs/main/linux-64::zstd-1.3.7-h0b5b093_0

#####################################################################################################################
#####################################################################################################################
#####################################################################################################################
(base) root@322f3cd47567:/# conda create --name tf_gpu tensorflow-gpu
Collecting package metadata (current_repodata.json): done
Solving environment: done

## Package Plan ##

  environment location: /root/anaconda3/envs/tf_gpu

  added / updated specs:
    - tensorflow-gpu


The following packages will be downloaded:

    package                    |            build
    ---------------------------|-----------------
    _tflow_select-2.1.0        |              gpu           2 KB
    absl-py-0.7.1              |           py37_0         158 KB
    astor-0.7.1                |           py37_0          44 KB
    c-ares-1.15.0              |    h7b6447c_1001         102 KB
    certifi-2019.6.16          |           py37_1         156 KB
    cudatoolkit-10.1.168       |                0       354.1 MB
    cudnn-7.6.0                |       cuda10.1_0       174.2 MB
    cupti-10.1.168             |                0         1.4 MB
    gast-0.2.2                 |           py37_0         155 KB
    google-pasta-0.1.7         |             py_0          41 KB
    grpcio-1.16.1              |   py37hf8bcb03_1         984 KB
    keras-applications-1.0.8   |             py_0          33 KB
    keras-preprocessing-1.1.0  |             py_1          36 KB
    libprotobuf-3.8.0          |       hd408876_0         2.9 MB
    markdown-3.1.1             |           py37_0         118 KB
    protobuf-3.8.0             |   py37he6710b0_0         620 KB
    tensorboard-1.14.0         |   py37hf484d3e_0         3.1 MB
    tensorflow-1.14.0          |gpu_py37h74c33d7_0           4 KB
    tensorflow-base-1.14.0     |gpu_py37he45bfe2_0       327.9 MB
    tensorflow-estimator-1.14.0|             py_0         291 KB
    tensorflow-gpu-1.14.0      |       h0d30ee6_0           3 KB
    termcolor-1.1.0            |           py37_1           8 KB
    ------------------------------------------------------------
                                           Total:       866.2 MB

The following NEW packages will be INSTALLED:

  _libgcc_mutex      pkgs/main/linux-64::_libgcc_mutex-0.1-main
  _tflow_select      pkgs/main/linux-64::_tflow_select-2.1.0-gpu
  absl-py            pkgs/main/linux-64::absl-py-0.7.1-py37_0
  astor              pkgs/main/linux-64::astor-0.7.1-py37_0
  blas               pkgs/main/linux-64::blas-1.0-mkl
  c-ares             pkgs/main/linux-64::c-ares-1.15.0-h7b6447c_1001
  ca-certificates    pkgs/main/linux-64::ca-certificates-2019.5.15-0
  certifi            pkgs/main/linux-64::certifi-2019.6.16-py37_1
  cudatoolkit        pkgs/main/linux-64::cudatoolkit-10.1.168-0
  cudnn              pkgs/main/linux-64::cudnn-7.6.0-cuda10.1_0
  cupti              pkgs/main/linux-64::cupti-10.1.168-0
  gast               pkgs/main/linux-64::gast-0.2.2-py37_0
  google-pasta       pkgs/main/noarch::google-pasta-0.1.7-py_0
  grpcio             pkgs/main/linux-64::grpcio-1.16.1-py37hf8bcb03_1
  h5py               pkgs/main/linux-64::h5py-2.9.0-py37h7918eee_0
  hdf5               pkgs/main/linux-64::hdf5-1.10.4-hb1b8bf9_0
  intel-openmp       pkgs/main/linux-64::intel-openmp-2019.4-243
  keras-applications pkgs/main/noarch::keras-applications-1.0.8-py_0
  keras-preprocessi~ pkgs/main/noarch::keras-preprocessing-1.1.0-py_1
  libedit            pkgs/main/linux-64::libedit-3.1.20181209-hc058e9b_0
  libffi             pkgs/main/linux-64::libffi-3.2.1-hd88cf55_4
  libgcc-ng          pkgs/main/linux-64::libgcc-ng-9.1.0-hdf63c60_0
  libgfortran-ng     pkgs/main/linux-64::libgfortran-ng-7.3.0-hdf63c60_0
  libprotobuf        pkgs/main/linux-64::libprotobuf-3.8.0-hd408876_0
  libstdcxx-ng       pkgs/main/linux-64::libstdcxx-ng-9.1.0-hdf63c60_0
  markdown           pkgs/main/linux-64::markdown-3.1.1-py37_0
  mkl                pkgs/main/linux-64::mkl-2019.4-243
  mkl-service        pkgs/main/linux-64::mkl-service-2.0.2-py37h7b6447c_0
  mkl_fft            pkgs/main/linux-64::mkl_fft-1.0.12-py37ha843d7b_0
  mkl_random         pkgs/main/linux-64::mkl_random-1.0.2-py37hd81dba3_0
  ncurses            pkgs/main/linux-64::ncurses-6.1-he6710b0_1
  numpy              pkgs/main/linux-64::numpy-1.16.4-py37h7e9f1db_0
  numpy-base         pkgs/main/linux-64::numpy-base-1.16.4-py37hde5b4d6_0
  openssl            pkgs/main/linux-64::openssl-1.1.1c-h7b6447c_1
  pip                pkgs/main/linux-64::pip-19.1.1-py37_0
  protobuf           pkgs/main/linux-64::protobuf-3.8.0-py37he6710b0_0
  python             pkgs/main/linux-64::python-3.7.3-h0371630_0
  readline           pkgs/main/linux-64::readline-7.0-h7b6447c_5
  scipy              pkgs/main/linux-64::scipy-1.3.0-py37h7c811a0_0
  setuptools         pkgs/main/linux-64::setuptools-41.0.1-py37_0
  six                pkgs/main/linux-64::six-1.12.0-py37_0
  sqlite             pkgs/main/linux-64::sqlite-3.29.0-h7b6447c_0
  tensorboard        pkgs/main/linux-64::tensorboard-1.14.0-py37hf484d3e_0
  tensorflow         pkgs/main/linux-64::tensorflow-1.14.0-gpu_py37h74c33d7_0
  tensorflow-base    pkgs/main/linux-64::tensorflow-base-1.14.0-gpu_py37he45bfe2_0
  tensorflow-estima~ pkgs/main/noarch::tensorflow-estimator-1.14.0-py_0
  tensorflow-gpu     pkgs/main/linux-64::tensorflow-gpu-1.14.0-h0d30ee6_0
  termcolor          pkgs/main/linux-64::termcolor-1.1.0-py37_1
  tk                 pkgs/main/linux-64::tk-8.6.8-hbc83047_0
  werkzeug           pkgs/main/noarch::werkzeug-0.15.4-py_0
  wheel              pkgs/main/linux-64::wheel-0.33.4-py37_0
  wrapt              pkgs/main/linux-64::wrapt-1.11.2-py37h7b6447c_0
  xz                 pkgs/main/linux-64::xz-5.2.4-h14c3975_4
  zlib               pkgs/main/linux-64::zlib-1.2.11-h7b6447c_3
