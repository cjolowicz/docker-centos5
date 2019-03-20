DIRS = openssl curl python git
ARCHS = x86_64 i386

all: tag

build:
	status=0 ; \
	for dir in $(DIRS) ; do \
	    for arch in $(ARCHS) ; do \
	        $(MAKE) -C $$dir ARCH=$$arch REPO=$(DOCKER_USERNAME) build || \
	            status=$$? ; \
	    done ; \
	done ; \
	exit $$status

tag:
	status=0 ; \
	for dir in $(DIRS) ; do \
	    for arch in $(ARCHS) ; do \
	        $(MAKE) -C $$dir ARCH=$$arch REPO=$(DOCKER_USERNAME) tag || \
	            status=$$? ; \
	    done ; \
	done ; \
	exit $$status

push:
	status=0 ; \
	for dir in $(DIRS) ; do \
	    for arch in $(ARCHS) ; do \
	        $(MAKE) -C $$dir ARCH=$$arch REPO=$(DOCKER_USERNAME) push || \
	            status=$$? ; \
	    done ; \
	done ; \
	exit $$status

login:
	echo "$(DOCKER_PASSWORD)" | docker login -u $(DOCKER_USERNAME) --password-stdin

.PHONY: all build tag push login
