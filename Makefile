.DEFAULT_GOAL := all
.PHONY: all help deps image tag release

DOCKER_BIN := docker
IMAGE_NAME := sslscan
NAMESPACE  := unbounce

all: help ## [DEFAULT] Display help

help: ## Display this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deps: ## Ensure required binaries and libs are installed
	@hash $(DOCKER_BIN) > /dev/null 2>&1 || \
		(echo "Install docker to continue."; exit 1)

image: ## Build a new docker image out of the local codebase
	$(DOCKER_BIN) build --pull --force-rm --no-cache -t $(IMAGE_NAME) .

tag: ## Tag a new version of the docker image
ifndef VERSION
	@(echo "Specify a VERSION to continue."; exit 1)
endif
	$(DOCKER_BIN) tag $(IMAGE_NAME) $(NAMESPACE)/$(IMAGE_NAME):$(VERSION)
	$(DOCKER_BIN) tag $(IMAGE_NAME) $(NAMESPACE)/$(IMAGE_NAME):latest

release: ## Push the tagged images to Docker Hub
ifndef VERSION
	@(echo "Specify a VERSION to continue."; exit 1)
endif
	$(DOCKER_BIN) push $(NAMESPACE)/$(IMAGE_NAME):$(VERSION)
	$(DOCKER_BIN) push $(NAMESPACE)/$(IMAGE_NAME):latest

