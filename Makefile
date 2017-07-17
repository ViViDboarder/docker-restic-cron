.PHONY: build-x86 build-arm build-all

DOCKER_TAG ?= docker-duplicity-cron

default: build-x86

build-x86:
	docker build -f ./Dockerfile.ubuntu -t $(DOCKER_TAG):ubuntu .

build-arm:
	docker build -f ./Dockerfile.raspbian -t $(DOCKER_TAG):raspbian .

build-all: build-x86 build-arm

test-x86: build-x86
	./test.sh $(DOCKER_TAG) ubuntu

test-arm: build-arm
	./test.sh $(DOCKER_TAG) raspbian

test-all: test-x86 test-arm

shell-x86: build-x86
	docker run --rm -it $(DOCKER_TAG):ubuntu bash

shell-arm: build-arm
	docker run --rm -it $(DOCKER_TAG):raspbian bash

shell: shell-x86
