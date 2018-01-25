FROM alpine:3.7

RUN apk --no-cache add \
	bash \
	curl \
	gettext \
	nginx \
	tini

ENV WORKER_USERNAME=nginx

RUN mkdir -p /data

ADD ./docker-entrypoint.sh /
ADD ./nginx.conf /etc/nginx/nginx.conf.tmpl

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx"]
