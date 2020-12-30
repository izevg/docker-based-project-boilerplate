#!/usr/bin/env make

##
# Console shortcuts. Useful for different environments.
##

.PHONY:

ifeq (${DOCKER__ENV},$(filter ${DOCKER__ENV},local dev))
###> Add here console calls for local & dev environments
###  Example:
#console__sample_backend_app:
#	@docker-compose -f docker-compose.yaml -f ./compose.d/docker-compose.local.yaml exec sample_backend_app sh

else
###> Swarm mode requires another way for calling a console, and it's cannot be easily done. Adding a guard here.
#console__sample_backend_app:
#	@echo "Cannot call the console for a service in the Swarm mode. Aborting"
#	exit 1
endif