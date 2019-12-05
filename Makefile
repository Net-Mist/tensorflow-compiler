tensorflow_pkg/tensorflow-2.0.0-cp38-cp38-linux_x86_64.whl:
	docker build -t netmist/tfdevel:0.1_CCC6.0 -f devel.Dockerfile --build-arg CACHE_STOP=$$(date +%s) . && \
	mkdir -p tensorflow_pkg && \
	docker run -it --rm --runtime=nvidia \
		-v $$(pwd)/tensorflow_pkg:/tensorflow_pkg \
		netmist/tfdevel:0.1_CCC6.0 /bin/bash -c "bazel build \
            --config=opt \
            //tensorflow/tools/pip_package:build_pip_package && \
        ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tensorflow_pkg"

build: tensorflow_pkg/tensorflow-2.0.0-cp38-cp38-linux_x86_64.whl
	docker build -t netmist/tensorflow:2.0.0_CCC6.0 .

build_bench:
	docker build -t $${BASE_IMAGE}_bench \
		--build-arg BASE_IMAGE=$${BASE_IMAGE} \
		-f bench.Dockerfile .

bench:
	docker run -it --rm --runtime=nvidia \
		-v $$(pwd)/benchmark_src:/bench \
		-v $${HOME}/.keras/models:/root/.keras/models $${BASE_IMAGE}_bench

bench_cpu:
	docker run -it --rm --runtime=nvidia -e CUDA_VISIBLE_DEVICES="" -v $$(pwd)/benchmark_src:/bench -v $${HOME}/.keras/models:/root/.keras/models $${BASE_IMAGE}_bench 

.SECONDARY:
