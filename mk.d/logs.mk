#!/usr/bin/env make

##
# Logs shortcuts. Useful for different environments.
##

.PHONY:

ifeq (${DOCKER__ENV},$(filter ${DOCKER__ENV},local dev))
###> Add here console calls for local & dev environments
###  Example:
#logs__sample_backend_app:
#	@docker-compose -f docker-compose.yaml -f ./compose.d/docker-compose.local.yaml logs -f sample_backend_app

else
#logs__sample_backend_app:
#	@docker service logs -f sample_backend_app
endif