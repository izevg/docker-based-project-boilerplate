#!/usr/bin/env make

##
# Global operations with an environment
##

.PHONY: env__init

###> You can also extend this target with all the side generators for your apps
env__init: decrypt__env build__all