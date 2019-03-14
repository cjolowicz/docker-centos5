OPENSSL = $(DOCKER_USERNAME)/openssl-centos5:1.1.0j
CURL    = $(DOCKER_USERNAME)/curl-centos5:7.64.0
GIT     = $(DOCKER_USERNAME)/git-centos5:2.21.0
PYTHON3 = $(DOCKER_USERNAME)/python3-centos5:3.6.8
IMAGES  = $(OPENSSL) $(CURL) $(GIT) $(PYTHON3)

all: build

build: build-curl build-git build-openssl build-python3

build-openssl: openssl/Dockerfile
	docker build -t $(OPENSSL) openssl

build-curl: build-openssl curl/Dockerfile
	docker build -t $(CURL) curl

build-git: build-curl git/Dockerfile
	docker build -t $(GIT) git

build-python3: build-curl python3/Dockerfile python3/use-local-openssl.patch
	docker build -t $(PYTHON3) python3

push: build
	echo "$(DOCKER_PASSWORD)" | docker login -u $(DOCKER_USERNAME) --password-stdin
	for image in $(IMAGES) ; do \
	    docker push $$image ; \
	    name=$${image%:*} fulltag=$${image#*:} ; \
	    for tag in $${fulltag%.*} $${fulltag%%.*} latest ; do \
	        docker tag $$image $$name:$$tag ; \
	        docker push $$name:$$tag ; \
	    done ; \
	done

.PHONY: all build build-openssl build-curl build-git build-python3 push
