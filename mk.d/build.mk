#!/usr/bin/env make

##
# Targets for building Docker images.
##

.PHONY: build__ansible

build__ansible:
	@echo "$(COLOR__YELLOW) Building/checking the Ansible image $(COLOR__DEFAULT)"
	@docker build -t ${COMPOSE_PROJECT_NAME}__ansible:latest ./app.d/ansible.internal.app
	@echo "$(COLOR__GREEN) Ansible image built successfully $(COLOR__DEFAULT)"

ifeq (${DOCKER__ENV},$(filter ${DOCKER__ENV},local dev))
###> Add here your builds with tagging for local & dev environments
###  Don't forget about possible preparation steps like .env and other configs generation!
###  Example:
#prepare__sample_backend_app:
#	@ ./sh.d/generate-sample_backend_app-env.sh
#
#build__sample_backend_app: prepare__sample_backend_app
#	@docker build --no-cache \
#	-t ${COMPOSE_PROJECT_NAME}__sample_backend_app:latest \
#	-f ./app.d/sample.backend.app/Dockerfile ./app.d/sample.backend.app/
#
#tag__sample_backend_app:
#	@docker tag \
#	${COMPOSE_PROJECT_NAME}__sample_backend_app:latest ${COMPOSE_PROJECT_NAME}__sample_backend_app:${DOCKER__ENV}

else ifeq (${DOCKER__ENV},$(filter ${DOCKER__ENV},staging production))
###> Add here your builds with tagging for staging/production environments, e.g. with a Container Registry tags
###  Example:
#prepare__sample_backend_app:
#	@ ./sh.d/generate-sample_backend_app-env.sh
#
#build__sample_backend_app: prepare__sample_backend_app
#	@docker build --no-cache \
#	-t ${COMPOSE_PROJECT_NAME}__sample_backend_app:latest \
#	-f ./app.d/sample.backend.app/Dockerfile ./app.d/sample.backend.app/
#
#tag__sample_backend_app:
#	@docker tag \
#	${COMPOSE_PROJECT_NAME}__sample_backend_app:latest ${REGISTRY_KEY__MY_SERVICE_NAME}__sample_backend_app:${DOCKER__ENV}

else
###> Add here the fallback guard for a wrong environment definition
###  Example:
#prepare__sample_backend_app:
#	@echo "Cannot operate with unknown environment. Aborting"
#	exit 1
#
#build__sample_backend_app: prepare__sample_backend_app
#	@echo "Cannot operate with unknown environment. Aborting"
#	exit 1
#
#tag__sample_backend_app:
#	@echo "Cannot operate with unknown environment. Aborting"
#	exit 1
endif

###> Now you can combine building with tagging
###  Example:
#process__sample_backend_app: build__sample_backend_app tag__sample_backend_app

###> And finally combine all the builds under one flow
#build__all: process__sample_backend_app process__sample_frontend_app process__sample_whatever_app
build__all:
	@echo "$(COLOR__YELLOW) Building all the available images... $(COLOR__DEFAULT)"
	@true
	@echo "$(COLOR__GREEN) All images have been built! $(COLOR__DEFAULT)"