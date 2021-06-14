DOCKER_TAG ?= docker-restic-cron

.PHONY: all
all: check test-all

.PHONY: default
default: build-x86

.PHONY: test
test: test-x86

.PHONY: build-x86
build-x86:
	docker build -f ./Dockerfile -t $(DOCKER_TAG) .

.PHONY: build-arm
build-arm:
	docker build --build-arg REPO=arm32v7 -f ./Dockerfile -t $(DOCKER_TAG)-arm32v7 .

.PHONY: build-all
build-all: build-x86 build-arm

.PHONY: test-x86
test-x86: build-x86
	cd tests && ./test.sh $(DOCKER_TAG)
	cd tests && ./test-pre-scripts.sh $(DOCKER_TAG)

.PHONY: test-all
test-all: test-x86 test-arm

.PHONY: test-s3-x86
test-s3-x86:
	cd tests && ./test-s3.sh ubuntu

.PHONY: test-s3-all
test-s3-all: test-s3-x86 test-s3-arm

.PHONY: shell-x86
shell-x86: build-x86
	docker run --rm -it $(DOCKER_TAG) bash

.PHONY: shell
shell: shell-x86

.PHONY: clean
clean:
	docker-compose -f docker-compose-test-s3.yml down -v

.PHONY: install-hooks
install-hooks:
	pre-commit install

.PHONY: check
check:
	pre-commit run --all-files
