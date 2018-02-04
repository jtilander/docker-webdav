ifeq ($(OS),Windows_NT)
	detected_OS := Windows
	export PWD?=$(shell echo %CD%)
	export SHELL=cmd
else
	detected_OS := $(shell uname -s)
endif

export IMAGENAME=jtilander/webdav-tests
export TAG?=test
VERBOSE?=1

BUILDOPTS?=

.PHONY: image run clean

image:
	docker build $(BUILDOPTS) -t $(IMAGENAME):$(TAG) .
	docker images $(IMAGENAME):$(TAG)

run:
	docker-compose -f open.yaml up --abort-on-container-exit --exit-code-from tests
	docker-compose -f basic.yaml up --abort-on-container-exit --exit-code-from tests
	#docker-compose -f ldap.yaml up --abort-on-container-exit --exit-code-from tests

clean:
	docker rmi $(IMAGENAME):$(TAG)
