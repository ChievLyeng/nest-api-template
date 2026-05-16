#Makefile

include ./include.mk

help:
	@echo "$(TAG) will build for $(CI_PROJECT_NAME)"
	@echo "make build    = build docker images"
	@echo "make push     = push image to repository"

vars := $(filter-out $(VARS_OLD) VARS_OLD,$(.VARIABLES))
export $(.VARIABLES)

config:
ifneq ($(wildcard overwrite.env),"")
	@cat ./docker.vars | /bin/bash ./build/scripts/build-env-docker.sh ./overwrite.env > .env
else
	@cat ./docker.vars | /bin/bash ./build/scripts/build-env-docker.sh  >  .env
endif

build-app:
	@echo "build image for $(IMG)/app"
	docker build -t "$(IMG)/app:$(TAG)" \
		-f build/app/Dockerfile .
ifneq ($(TAG), dev)
	docker tag "$(IMG)/app:$(TAG)" "$(IMG)/app:testing"
endif

build: build-app
	@echo "done building image for $(CI_PROJECT_NAME)"

push:
	docker push $(IMG)/app:$(TAG)
ifneq ($(TAG), dev)
	docker push $(IMG)/app:testing
endif

tag-prod:
	docker tag $(IMG)/app:$(TAG) $(IMG)/app:production
	docker push $(IMG)/app:production
