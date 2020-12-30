#!/usr/bin/env make

##
# Docker Swarm targets.
# Remove this if you're using another orchestrator in your environment
##

swarm__init:
	@docker swarm init

swarm__deploy:

swarm__remove:

swarm__status:

swarm__rebalance:
