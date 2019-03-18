all: build

build: Dockerfile.m4
	m4 -P Dockerfile.m4 | docker build -f - -t $(IMAGE) .

tag: build
	image=$(IMAGE) ; \
	name=$${image%:*} fulltag=$${image#*:} ; \
	for tag in $${fulltag%.*} $${fulltag%%.*} latest ; do \
	    docker tag $$image $$name:$$tag ; \
	done

push: tag
	image=$(IMAGE) ; \
	docker push $$image ; \
	name=$${image%:*} fulltag=$${image#*:} ; \
	for tag in $${fulltag%.*} $${fulltag%%.*} latest ; do \
	    docker tag $$image $$name:$$tag ; \
	    docker push $$name:$$tag ; \
	done

.PHONY: all build push
