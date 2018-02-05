#!/bin/sh
set -e

export VERSION=$(cat /version.txt)
echo "Now running jtilander/webdav $VERSION"


export WEBDAV_USERNAME=${WEBDAV_USERNAME:-guest}
export LISTENPORT=${LISTENPORT:-636}
export WORKER_COUNT=${WORKER_COUNT:-4}
export WORKER_CONNECTIONS=${WORKER_CONNECTIONS:-1024}
export WORKER_USERNAME=${WORKER_USERNAME:-nginx}
export LISTFORMAT=${LISTFORMAT:-json}
export SENDFILE=${SENDFILE:-on}
export TCP_NOPUSH=${TCP_NOPUSH:-off}
export TRUSTED_SUBNET=${TRUSTED_SUBNET:-all}

export LDAP_PROTOCOL=${LDAP_PROTOCOL:-ldaps}
export LDAP_PORT=${LDAP_PORT:-3268}
export LDAP_SERVER=${LDAP_SERVER}
export LDAP_DN=${LDAP_DN}
export LDAP_DOMAIN=${LDAP_DOMAIN}
export LDAP_BIND_USER=${LDAP_BIND_USER}
export LDAP_BIND_PASSWORD=${LDAP_BIND_PASSWORD}
export USE_PERFLOG=${USE_PERFLOG:0}

chown -R ${WORKER_USERNAME} /data
chown -R ${WORKER_USERNAME} /tmp/uploads

if [ "$USE_PERFLOG" = "1" ]; then
	export ACCESS_LOG_STATEMENT='access_log  /log/access.log upstream_time;'
fi

envsubst '${WORKER_COUNT} ${WORKER_CONNECTIONS} ${WORKER_USERNAME} ${LISTFORMAT} ${SENDFILE} ${TCP_NOPUSH} ${ACCESS_LOG_STATEMENT}' > /etc/nginx/nginx.conf < /etc/nginx/nginx.conf.templ

if [ ! -z "$LDAP_BIND_USER" ]; then
	# Request LDAP configuration
	SOURCE_TEMPLATE=nginx.ldap.conf.templ
	touch /etc/nginx/.htpasswd
elif [ "$WEBDAV_USERNAME" != "guest" ]; then
	# Request basic auth configuration
	SOURCE_TEMPLATE=nginx.basic.conf.templ
	htpasswd -cb /etc/nginx/.htpasswd "${WEBDAV_USERNAME}" "${WEBDAV_PASSWORD}"
else
	# Request default world read/write
	SOURCE_TEMPLATE=nginx.open.conf.templ
	touch /etc/nginx/.htpasswd
fi

envsubst '${LISTFORMAT} ${LDAP_PORT} ${LDAP_PROTOCOL} ${LDAP_DN} ${LDAP_SERVER} ${LDAP_DOMAIN} ${LDAP_BIND_USER} ${LDAP_BIND_PASSWORD} ${TRUSTED_SUBNET} ${LISTENPORT}' > /etc/nginx/conf.d/default.conf < /etc/nginx/conf.d/${SOURCE_TEMPLATE}

if [ "$1" = "nginx" ]; then
	shift

	if [ "$VERBOSE" = "1" ]; then
		cat /etc/nginx/nginx.conf
		cat /etc/nginx/conf.d/*.conf
		cat /etc/nginx/.htpasswd
	fi

	exec /usr/sbin/nginx -g "daemon off;"

fi

exec "$@"
