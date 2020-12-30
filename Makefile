#!/usr/bin/env make

# Optionally include .env (it couldn't exist in case of fresh installation)
-include .env
export $(shell sed 's/=.*//' .env)

export COLOR__RED = \n\t\033[01;31m
export COLOR__GREEN = \n\t\033[01;32m
export COLOR__YELLOW = \n\t\033[01;33m
export COLOR__DEFAULT = \033[0m\n

###> IMPORTANT: define the COMPOSE_PROJECT_NAME here so
###> Makefile's targets will be able to perform shell magic.
###> Also, the value here and value in the .env should be the same, that's important
export COMPOSE_PROJECT_NAME=docker-project-boilerplate

include ./mk.d/build.mk
include ./mk.d/console.mk
include ./mk.d/environment.mk
include ./mk.d/logs.mk
include ./mk.d/operations.mk
include ./mk.d/registry.mk
include ./mk.d/secrets.mk

###> Optional and probably could be removed in case of using any other orchestrator
include ./mk.d/swarm.mk.mk