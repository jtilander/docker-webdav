#!/bin/sh
set -e

if [ "$1" = "nginx" ]; then
	shift

	export WORKER_COUNT=${WORKER_COUNT:-4}
	export WORKER_CONNECTIONS=${WORKER_CONNECTIONS:-1024}
	export WORKER_USERNAME=${WORKER_USERNAME:-www-data}
	export LISTFORMAT=${LISTFORMAT:-json}

	export SENDFILE=${SENDFILE:-on}
	export TCP_NOPUSH=${TCP_NOPUSH:-off}
	export TRUSTED_SUBNET=${TRUSTED_SUBNET:-all}

	chown -R ${WORKER_USERNAME} /data
	chown -R ${WORKER_USERNAME} /tmp/uploads

	if [ "$USERNAME" = "" ]; then
		export PERMISSIONS="user:rw group:rw all:rw"
		touch /etc/nginx/.htpasswd
	else
		export PERMISSIONS="user:rw group:r all:r"
		htpasswd -cb /etc/nginx/.htpasswd "${USERNAME}" "${PASSWORD}"
	fi

	envsubst '${WORKER_COUNT} ${WORKER_CONNECTIONS} ${WORKER_USERNAME} ${LISTFORMAT} ${SENDFILE} ${TCP_NOPUSH} ${PERMISSIONS} ${TRUSTED_SUBNET}' > /etc/nginx/nginx.conf < /etc/nginx/nginx.conf.tmpl


	if [ "$VERBOSE" = "1" ]; then
		cat /etc/nginx/nginx.conf
		cat /etc/nginx/.htpasswd
	fi

	exec /usr/sbin/nginx -g "daemon off;"

fi

exec "$@"
