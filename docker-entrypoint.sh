#!/bin/bash
set -e

if [ "$1" = "nginx" ]; then
	shift

	export WORKER_COUNT=${WORKER_COUNT:-4}
	export WORKER_CONNECTIONS=${WORKER_CONNECTIONS:-1024}
	export WORKER_USERNAME=${WORKER_USERNAME:-www-data}
	
	chown -R ${WORKER_USERNAME} /data

	envsubst '${WORKER_COUNT} ${WORKER_CONNECTIONS} ${WORKER_USERNAME}' > /etc/nginx/nginx.conf < /etc/nginx/nginx.conf.tmpl

	exec /usr/sbin/nginx -g "daemon off;"

fi

exec "$@"
