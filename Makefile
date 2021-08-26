DEFAULT_ENV_FILE := .env
ifneq ("$(wildcard $(DEFAULT_ENV_FILE))","")
include ${DEFAULT_ENV_FILE}
export $(shell sed 's/=.*//' ${DEFAULT_ENV_FILE})
endif

ENV_FILE := .env.local
ifneq ("$(wildcard $(ENV_FILE))","")
include ${ENV_FILE}
export $(shell sed 's/=.*//' ${ENV_FILE})
endif


##################################

.PHONY: setup
setup: setup-rhods setup-sandbox


##################################

.PHONY: setup-rhods
setup-rhods:
	./setup-rhods.sh

##################################

.PHONY: setup-sandbox
setup-sandbox:
	./setup-sandbox.sh

##################################

.PHONY: cleanup
cleanup: cleanup-rhods cleanup-sandbox

##################################

.PHONY: cleanup-rhods
cleanup-rhods:
	./cleanup-rhods.sh

##################################

.PHONY: cleanup-sandbox
cleanup-sandbox:
	./cleanup-sandbox.sh

##################################
