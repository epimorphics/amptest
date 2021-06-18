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
	docker build --tag ${REPO}:${TAG} .

publish: image
	aws ecr describe-repositories --region ${AWS_REGION} --repository-names ${IMAGE}
	docker pull ${REPO}:SNAPSHOT 2>&1
	docker push ${REPO}:${TAG} 2>&1
