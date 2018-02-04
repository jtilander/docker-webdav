FROM alpine:3.7

RUN apk --no-cache add \
	bash \
	curl \
	py3-requests \
	python3 \
	tini

RUN mkdir -p /app
COPY docker-entrypoint.sh /
COPY *.py /app/

ENTRYPOINT ["/sbin/tini", "-g", "/docker-entrypoint.sh"]
CMD ["tests"]
