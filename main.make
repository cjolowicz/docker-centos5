all: build

build: Dockerfile
	docker build -t $(IMAGE) .

push: build
	image=$(IMAGE) ; \
	docker push $$image ; \
	name=$${image%:*} fulltag=$${image#*:} ; \
	for tag in $${fulltag%.*} $${fulltag%%.*} latest ; do \
	    docker tag $$image $$name:$$tag ; \
	    docker push $$name:$$tag ; \
	done

.PHONY: all build push
