SHELL := /bin/bash

IMAGE_NAME=hello-world
DOCKERFILE=Dockerfile
DOCKER_TAG=1.0

#Prompt for docker username and password
DOCKER_USERNAME ?= $(shell bash -c 'read -p "Enter Docker username: " u; echo $$u')
DOCKER_PASSWORD ?= $(shell bash -c 'read -s -p "Enter Docker password: " p; echo $$p')

# Prompt for Terraform environment variables

# Prompt for the desired domain name of the application.
DOMAIN_NAME ?= $(shell bash -c 'read -p "Enter desired domain name of application: " n; echo $$n')

# Prompt for the sender's email address. This will be used as the "from" address for alerts.
EMAIL_FROM ?= $(shell bash -c 'read -p "Enter senders email address: " m; echo $$m')

# Prompt for the recipient's email address. Alerts will be sent to this address.
EMAIL_TO ?= $(shell bash -c 'read -p "Enter recipients email address: " o; echo $$o')

# Prompt for the email user. This will typically be the username used for SMTP authentication.
EMAIL_USER ?= $(shell bash -c 'read -p "Enter email user: " l; echo $$l')

# Prompt for the email user. This will typically be the username used for SMTP authentication.
EMAIL_HOST ?= $(shell bash -c 'read -p "Enter email host (ex. host:port): " r; echo $$r')

# Prompt for the email password. This will be used for SMTP authentication.
EMAIL_PASS ?= $(shell bash -c 'read -s -p "Enter email password: " k; echo $$k')


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
	terraform -chdir=terraform/ init

#run terraform plan
plan:
	terraform -chdir=terraform/ plan -var='email_auth={"email_to":"$(EMAIL_TO)", "email_from":"$(EMAIL_FROM)", "email_user":"$(EMAIL_USER)", "email_pass":"${EMAIL_PASS}", "email_host":"$(EMAIL_HOST)"}' -var='domain="$(DOMAIN_NAME)"'

#run terraform apply
apply: init plan
	terraform -chdir=terraform/ apply -auto-approve -var='email_auth={"email_to":"$(EMAIL_TO)", "email_from":"$(EMAIL_FROM)", "email_user":"$(EMAIL_USER)", "email_pass":"${EMAIL_PASS}", "email_host":"$(EMAIL_HOST)"}' -var='domain="$(DOMAIN_NAME)"'

#destroy terraform
destroy:
	terraform -chdir=terraform/ destroy

all: install-kind docker-build docker-login docker-push init plan apply 

.PHONY: install-kind docker-build docker-login docker-push init plan apply destroy all
	