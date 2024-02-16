SHELL := /bin/bash

IMAGE_NAME=hello-world
DOCKERFILE=Dockerfile
DOCKER_TAG=1.0

#Prompt for docker username and password
DOCKER_USERNAME ?= $(shell bash -c 'read -p "Enter Docker username: " u; echo $$u')
DOCKER_PASSWORD ?= $(shell bash -c 'read -s -p "Enter Docker password: " p; echo $$p')

# Prompt for terraform env variables
DOMAIN_NAME ?= $(shell bash -c 'read -p "Enter desired domain name of application: " n; echo $$n')
EMAIL_FROM ?= $(shell bash -c 'read -p "Enter senders"')
EMAIL_TO ?=
EMAIL_USER
EMAIL_PASS

#install kind
install-kind:
	@echo "Setting-up kind cluster..."
	./setup-kind.sh 

#build docker image
docker-build:
	docker build -t $(IMAGE_NAME):$(DOCKER_TAG) -f $(DOCKERFILE) .

#login to docker
docker-login:
	@echo "$(DOCKER_PASSWORD)" | docker login -u "$(DOCKER_USERNAME)" --password-stdin

#push image to docker
docker-push: docker-login
	docker tag $(IMAGE_NAME):$(DOCKER_TAG) $(DOCKER_USERNAME)/$(IMAGE_NAME):$(DOCKER_TAG)
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(DOCKER_TAG)

#initialize terraform
init:
	cd ./terraform && terraform init

#run terraform plan
plan:
	cd ./terraform && terraform plan

#run terraform apply
apply: init plan
	cd ./terraform && terraform apply -auto-approve /
	 -var='email_auth{"email_to":"$(EMAIL_TO)", "email_from":"$(EMAIL_FROM)", "email_user":"$(EMAIL_USER)", "email_pass":"${EMAIL_PASS}"}'
	 -var='domain="$(DOMAIN_NAME)"'

#destroy terraform
destroy:
	cd ./terraform && terraform destroy

all: install-kind docker-build docker-login docker-push init plan apply 

.PHONY: install-kind docker-build docker-login docker-push init plan apply destroy all
	