#!/usr/bin/env make

##
# Common environmental operations
##

.PHONY: up stop restart status generate__certs

generate__certs:
	@ ./sh.d/certgen.sh

ifeq (${DOCKER__ENV},$(filter ${DOCKER__ENV},local dev))
up:
	@docker-compose -f docker-compose.yaml -f ./compose.d/docker-compose.${DOCKER__ENV}.yaml up -d

stop:
	@docker-compose -f docker-compose.yaml -f ./compose.d/docker-compose.${DOCKER__ENV}.yaml stop

status:
	@docker-compose -f docker-compose.yaml -f ./compose.d/docker-compose.${DOCKER__ENV}.yaml ps

else ifeq (${DOCKER__ENV},$(filter ${DOCKER__ENV},staging production))
up:
	@echo "You cannot perform this operation in the swarm mode"
	exit 1

stop:
	@echo "You cannot perform this operation in the swarm mode"
	exit 1

status: swarm__status

else
up:
	@echo "Unknown environment provided! Aborting"
	exit 1

stop:
	@echo "Unknown environment provided! Aborting"
	exit 1

status:
	@echo "Unknown environment provided! Aborting"
	exit 1

endif

restart: stop start