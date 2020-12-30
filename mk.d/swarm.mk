#!/usr/bin/env make

##
# Docker Swarm targets.
# Remove this if you're using another orchestrator in your environment
##

swarm__init:
	@docker swarm init
	@docker network create --driver=overlay --attachable "${COMPOSE_PROJECT_NAME}__${DOCKER__ENV}__overlay_network" || true

swarm__deploy: registry__authenticate
	@docker stack deploy --with-registry-auth -c docker-compose.yaml -c "compose.d/docker-compose.${DOCKER__ENV}.yaml" ${COMPOSE_PROJECT_NAME}

swarm__remove:
	@docker stack rm ${COMPOSE_PROJECT_NAME}

swarm__status:
	@docker stack ps ${COMPOSE_PROJECT_NAME}

swarm__rebalance:
	###> Place here all the needed services to rebalance in the case of need
	###  Example:
	###  @docker service update "${COMPOSE_PROJECT_NAME}__${DOCKER__ENV}__sample_backend_app" --force
	@true
