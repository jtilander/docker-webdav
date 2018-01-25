FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
	apt-get install -yq --no-install-recommends \
		curl \
		gettext \
		nginx \
		nginx-extras \
		&& \
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /data

ADD ./docker-entrypoint.sh /
ADD ./nginx.conf /etc/nginx/nginx.conf.tmpl

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx"]
