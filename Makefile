ifeq ($(OS),Windows_NT)
	detected_OS := Windows
	export PWD?=$(shell echo %CD%)
	export SHELL=cmd
	export VERSION=unknown
else
	detected_OS := $(shell uname -s)
	export VERSION=$(shell git describe --tags --dirty 2>/dev/null || echo unknown)
endif

export IMAGENAME=jtilander/webdav
export TAG?=test
VERBOSE?=1
WEBDAV_USERNAME?=bob
WEBDAV_PASSWORD?=initech
LISTENPORT?=3334

LDAP_SERVER?=rocket.acme.com
LDAP_DN?=DC=acme,DC=com
LDAP_DOMAIN?=acme
LDAP_BIND_USER?=
LDAP_BIND_PASSWORD=roadrunner
USE_PERFLOG?=0

BUILDOPTS?=

.PHONY: image tests run clean

image:
	docker build --build-arg VERSION=$(VERSION) $(BUILDOPTS) -t $(IMAGENAME):$(TAG) .
	docker images $(IMAGENAME):$(TAG)

run:
	docker run --env-file=.env --rm \
		-e VERBOSE=$(VERBOSE) \
		-e WEBDAV_USERNAME=$(WEBDAV_USERNAME) \
		-e WEBDAV_PASSWORD=$(WEBDAV_PASSWORD) \
		-e LISTENPORT=$(LISTENPORT) \
		-e USE_PERFLOG=$(USE_PERFLOG) \
		-v $(PWD)/tmp/data:/data \
		-v $(PWD)/tmp/logs:/log \
		-v $(PWD)/tmp/uploads:/tmp/uploads \
		-p $(LISTENPORT):$(LISTENPORT) \
		$(IMAGENAME):$(TAG)

runhost:
	docker run --net=host --env-file=.env --rm \
		-e VERBOSE=$(VERBOSE) \
		-e WEBDAV_USERNAME=$(WEBDAV_USERNAME) \
		-e WEBDAV_PASSWORD=$(WEBDAV_PASSWORD) \
		-e LISTENPORT=$(LISTENPORT) \
		-e USE_PERFLOG=$(USE_PERFLOG) \
		-v $(PWD)/tmp/data:/data \
		-v $(PWD)/tmp/logs:/log \
		-v $(PWD)/tmp/uploads:/tmp/uploads \
		$(IMAGENAME):$(TAG)

tests: image
	$(MAKE) -C tests image run

clean:
	-docker run --rm -v $(PWD):/data alpine:3.7 rm -rf /data/tmp
	docker rmi $(IMAGENAME):$(TAG)
