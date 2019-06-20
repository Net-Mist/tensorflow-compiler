tensorflow_pkg/tf_nightly_gpu-1.13.1-cp36-cp36m-linux_x86_64.whl:
	docker build -t net-mist/tfdevel:0.1 -f devel.Dockerfile --build-arg CACHE_STOP=$(date +%s) . && \
	mkdir -p tensorflow_pkg && \
	docker run -it --rm --runtime=nvidia \
		-v $$(pwd)/tensorflow_pkg:/tensorflow_pkg \
		net-mist/tfdevel:0.1

build: tensorflow_pkg/tf_nightly_gpu-1.13.1-cp36-cp36m-linux_x86_64.whl
	docker build -t net-mist/tf:0.1 .

.SECONDARY:
