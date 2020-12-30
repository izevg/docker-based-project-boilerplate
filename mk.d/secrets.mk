#!/usr/bin/env make

.PHONY: encrypt__env decrypt__env process__certs

encrypt__env: build__ansible
	@ ./sh.d/secrets-env.sh encrypt

decrypt__env: build__ansible
	@ ./sh.d/secrets-env.sh decrypt

process__certs:
	@ ./sh.d/secrets-certs.sh
