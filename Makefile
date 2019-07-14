tensorflow_opt_pkg/tensorflow-1.14.0-cp36-cp36m-linux_x86_64.whl:
	docker build -t netmist/tfdevel:0.1 -f devel.Dockerfile \
		--build-arg OPTIONS="--config=opt" \
		--build-arg CACHE_STOP=$(date +%s) . && \
	mkdir -p tensorflow_opt_pkg && \
	docker run -it --rm --runtime=nvidia \
		-v $$(pwd)/tensorflow_pkg:/tensorflow_pkg \
		net-mist/tfdevel:0.1

build_opt: tensorflow_opt_pkg/tensorflow-1.14.0-cp36-cp36m-linux_x86_64.whl
	docker build -t \
	 --build-arg TENSORFLOW_PATH="tensorflow_opt_pkg"\
	netmist/tf:1.14.0-opt .

.SECONDARY:
