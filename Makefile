.PHONY:	image publish

ACCOUNT?=$(shell aws sts get-caller-identity | jq -r .Account)
AWS_REGION?=eu-west-1
STAGE?=dev
NAME?=amptest
ECR?=${ACCOUNT}.dkr.ecr.eu-west-1.amazonaws.com
STORE?=epimorphics
TAG?=SNAPSHOT

IMAGE?=${STORE}/${NAME}/${STAGE}
REPO?=${ECR}/${IMAGE}

all: publish

image:
	@echo Building ${REPO}:${TAG} ...
	@docker build --tag ${REPO}:${TAG} .
	@echo Done.

publish: image
	@echo Publishing image: ${REPO}:${TAG} ...
	@docker push ${REPO}:${TAG} 2>&1
	@echo Done.
