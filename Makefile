tensorflow_opt_pkg/tensorflow-1.14.0-cp36-cp36m-linux_x86_64.whl:
	docker build -t netmist/tfdevel:0.1 -f devel.Dockerfile \
		--build-arg CACHE_STOP=$$(date +%s) . && \
	mkdir -p tensorflow_opt_pkg && \
	docker run -it --rm --runtime=nvidia \
		-v $$(pwd)/tensorflow_opt_pkg:/tensorflow_pkg \
		netmist/tfdevel:0.1 /bin/bash -c "bazel build \
            --config=opt \
			--copt=-march=native \
            --config=cuda \
            --config=noaws \
            --config=nohdfs \
            --config=noignite \
            --config=nokafka \
            //tensorflow/tools/pip_package:build_pip_package && \
        ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tensorflow_pkg"

build_opt: tensorflow_opt_pkg/tensorflow-1.14.0-cp36-cp36m-linux_x86_64.whl
	docker build -t netmist/tf:1.14.0-opt \
	 --build-arg TENSORFLOW_PATH="tensorflow_opt_pkg"\
	 .

tensorflow_avx2_avx512f_fma_pkg/tensorflow-1.14.0-cp36-cp36m-linux_x86_64.whl:
	docker build -t netmist/tfdevel:0.1 -f devel.Dockerfile \
		--build-arg CACHE_STOP=$$(date +%s) . && \
	mkdir -p tensorflow_avx2_avx512f_fma_pkg && \
	docker run -it --rm --runtime=nvidia \
		-v $$(pwd)/tensorflow_avx2_avx512f_fma_pkg:/tensorflow_pkg \
		netmist/tfdevel:0.1 /bin/bash -c "bazel build \
            --config=opt \
			--copt=-mavx2 --copt=-mavx512f --copt=-O3 --copt=-mfma --copt=-mfpmath=both --copt=-msse4.2 \
            --config=cuda \
            --config=noaws \
            --config=nohdfs \
            --config=noignite \
            --config=nokafka \
            //tensorflow/tools/pip_package:build_pip_package && \
        ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tensorflow_pkg"

build_avx2_avx512f_fma: tensorflow_avx2_avx512f_fma_pkg/tensorflow-1.14.0-cp36-cp36m-linux_x86_64.whl
	docker build -t netmist/tf:1.14.0-avx2-avx512f-fma \
	 --build-arg TENSORFLOW_PATH="tensorflow_avx2_avx512f_fma_pkg"\
	 .


tensorflow_avx2_fma_pkg/tensorflow-1.14.0-cp36-cp36m-linux_x86_64.whl:
	docker build -t netmist/tfdevel:0.1 -f devel.Dockerfile \
		--build-arg CACHE_STOP=$$(date +%s) . && \
	mkdir -p tensorflow_avx2_fma_pkg && \
	docker run -it --rm --runtime=nvidia \
		-v $$(pwd)/tensorflow_avx2_fma_pkg:/tensorflow_pkg \
		netmist/tfdevel:0.1 /bin/bash -c "bazel build \
            --config=opt \
			--copt=-mavx2 --copt=-O3 --copt=-mfma --copt=-mfpmath=both --copt=-msse4.2 \
            --config=cuda \
            --config=noaws \
            --config=nohdfs \
            --config=noignite \
            --config=nokafka \
            //tensorflow/tools/pip_package:build_pip_package && \
        ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tensorflow_pkg"

build_avx2_fma: tensorflow_avx2_fma_pkg/tensorflow-1.14.0-cp36-cp36m-linux_x86_64.whl
	docker build -t netmist/tf:1.14.0-avx2-fma \
	 --build-arg TENSORFLOW_PATH="tensorflow_avx2_fma_pkg"\
	 .


tensorflow_avx2_avx512f_fma_6.0_pkg/tensorflow-1.14.0-cp36-cp36m-linux_x86_64.whl:
	docker build -t netmist/tfdevel:0.1 -f devel.Dockerfile \
		--build-arg CACHE_STOP=$$(date +%s) \
		--build-arg TF_CUDA_COMPUTE_CAPABILITIES=6.0,6.1,7.0 . && \
	mkdir -p tensorflow_avx2_avx512f_fma_6.0_pkg && \
	docker run -it --rm --runtime=nvidia \
		-v $$(pwd)/tensorflow_avx2_avx512f_fma_6.0_pkg:/tensorflow_pkg \
		netmist/tfdevel:0.1 /bin/bash -c "bazel build \
            --config=opt \
			--copt=-mavx2 --copt=-mavx512f --copt=-O3 --copt=-mfma --copt=-mfpmath=both --copt=-msse4.2 \
            --config=cuda \
            --config=noaws \
            --config=nohdfs \
            --config=noignite \
            --config=nokafka \
            //tensorflow/tools/pip_package:build_pip_package && \
        ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tensorflow_pkg"

build_avx2_avx512f_fma_6.0: tensorflow_avx2_avx512f_fma_6.0_pkg/tensorflow-1.14.0-cp36-cp36m-linux_x86_64.whl
	docker build -t netmist/tf:1.14.0-avx2-avx512f-fma-6.0 \
	 --build-arg TENSORFLOW_PATH="tensorflow_avx2_avx512f_fma_6.0_pkg"\
	 .

.SECONDARY:
