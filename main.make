all: build tag

build: Dockerfile.m4
	m4 -P -D ARCH=$(ARCH) -D REPO=$(REPO) Dockerfile.m4 | \
	    docker build -f - -t $(IMAGE) .

tag: build
	status=0 ; \
	for tag in $(TAGS) ; do \
	    docker tag $(IMAGE) $(IMAGE):$$tag || status=$$? ; \
	done ; \
	return $$status

push: tag
	status=0 ; \
	docker push $(IMAGE) ; \
	for tag in $(TAGS) ; do \
	    docker push $(IMAGE):$$tag || status=$$? ; \
	done ; \
	return $$status

.PHONY: all build tag push
