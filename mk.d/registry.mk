#!/usr/bin/env make

##
# Container Registry operations.
##

.PHONY: registry__authenticate

registry__authenticate:
	###> Add here actual authentication depending on your CR
	@true

registry__pull:


###> Add here your containers publishing, e.g.
# registry__publish__sample_backend_app: registry__authenticate build__sample_backend_app tag__sample_backend_app
# 	@docker push ${REGISTRY_KEY__MY_SERVICE_NAME}__my-service-name:${DOCKER__ENV}