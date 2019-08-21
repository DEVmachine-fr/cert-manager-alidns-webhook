IMAGE_NAME := "webhook"
IMAGE_TAG := "latest"

OUT := $(shell pwd)/_out

$(shell mkdir -p "$(OUT)")

verify:
	go test -v .

build:
	docker build -t "$(IMAGE_NAME):$(IMAGE_TAG)" .

.PHONY: rendered-manifest.yaml
rendered-manifest.yaml:
	helm template \
	    --name alidns-webhook \
        --set image.repository=$(IMAGE_NAME) \
        --set image.tag=$(IMAGE_TAG) \
        deploy/alidns-webhook > "$(OUT)/rendered-manifest.yaml"
