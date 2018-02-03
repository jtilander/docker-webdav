# Nginx WebDAV container

A quick and dirty container that serves data over WEBDAV in an nginx container.


# Volumes

|Path|Description|
|----|-----------|
|/data|Exported data|
|/tmp/upload|Temporary storage for uploads|


# Environment variables

|Name|Default|Description|
|----|-------|-----------|
|USERNAME|<empty>|If set, this is the user that will have password access for RW|
|PASSWORD||Set to password of the user|
|WORKER_COUNT|4|Nginx worker processes|
|WORKER_CONNECTIONS|1024|Nginx max connections|
|WORKER_USERNAME|www-data|Run as this user|
|LISTFORMAT|json|How we return directory listings|
|SENDFILE|on|Nginx sendfile enabled?|
|TCP_NOPUSH|off|Nginx tcp_nopush?|
|TRUSTED_SUBNET|all|Only allow write from here|

# Resources

* https://nginx.org/en/docs/http/ngx_http_dav_module.html
* https://thoughts.t37.net/nginx-optimization-understanding-sendfile-tcp-nodelay-and-tcp-nopush-c55cdd276765
* https://www.nginx.com/resources/admin-guide/serving-static-content/

# TODO:

* Slim down image via alpine
* Configure security (currently everyone can do anything)


# Alternatives

* https://github.com/jgeusebroek/docker-webdav
