ifeq ($(OS),Windows_NT)
	detected_OS := Windows
	export PWD?=$(shell echo %CD%)
	export SHELL=cmd
else
	detected_OS := $(shell uname -s)
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

BUILDOPTS?=

.PHONY: image tests run clean

image:
	docker build $(BUILDOPTS) -t $(IMAGENAME):$(TAG) .
	docker images $(IMAGENAME):$(TAG)

run:
	docker run --rm \
		-e VERBOSE=$(VERBOSE) \
		-e WEBDAV_USERNAME=$(WEBDAV_USERNAME) \
		-e WEBDAV_PASSWORD=$(WEBDAV_PASSWORD) \
		-e LISTENPORT=$(LISTENPORT) \
		-e LDAP_SERVER=$(LDAP_SERVER) \
		-e LDAP_DN=$(LDAP_DN) \
		-e LDAP_DOMAIN=$(LDAP_DOMAIN) \
		-e LDAP_BIND_USER=$(LDAP_BIND_USER) \
		-e LDAP_PASSWORD=$(LDAP_BIND_PASSWORD) \
		-v $(PWD)/tmp:/data \
		-p $(LISTENPORT):$(LISTENPORT) \
		$(IMAGENAME):$(TAG)


tests: image
	$(MAKE) -C tests image run

clean:
	-docker run --rm -v $(PWD):/data alpine:3.7 rm -rf /data/tmp
	docker rmi $(IMAGENAME):$(TAG)