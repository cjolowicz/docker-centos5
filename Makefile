OPENSSL = openssl-centos5:1.1.0j
CURL    = curl-centos5:7.64.0
GIT     = git-centos5:2.21.0
PYTHON3 = python3-centos5:3.6.8
IMAGES  = $(OPENSSL) $(CURL) $(GIT) $(PYTHON3)

all: build

build: build-curl build-git build-openssl build-python3

build-openssl: openssl/Dockerfile
	docker build -t "$$DOCKER_USERNAME"/$(OPENSSL) openssl

build-curl: build-openssl curl/Dockerfile
	docker build -t "$$DOCKER_USERNAME"/$(CURL) curl

build-git: build-curl git/Dockerfile
	docker build -t "$$DOCKER_USERNAME"/$(GIT) git

build-python3: build-curl python3/Dockerfile python3/use-local-openssl.patch
	docker build -t "$$DOCKER_USERNAME"/$(PYTHON3) python3

push: build
	echo "$$DOCKER_PASSWORD" | docker login -u "$$DOCKER_USERNAME" --password-stdin
	for image in $(IMAGES) ; do \
	    docker push "$$DOCKER_USERNAME"/$$image ; \
	done

.PHONY: all build build-openssl build-curl build-git build-python3 push
