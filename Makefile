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
	@[ -z "${TAG}" ] || docker build --tag ${REPO}:${TAG} .

publish: image
	@docker push ${REPO}:${TAG}
