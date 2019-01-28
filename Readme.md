# Nginx WebDAV container

A quick and dirty container that serves data over WEBDAV in an nginx container.

# Volumes

|Path|Description|
|----|-----------|
|/data|Exported data, if you want to persist, map this path.|
|/tmp/upload|Temporary storage for uploads. Map for speed.|
|/log|A copy of the access log will be written here if USE_PERFLOG=1|

# Environment variables

|Name|Default|Description|
|----|-------|-----------|
|WEBDAV_USERNAME|guest|If set to guest: world RW w/o password. Otherwise, user gets RW and others get R|
|WEBDAV_PASSWORD||Set to password of the user|
|WORKER_COUNT|4|Nginx worker processes|
|WORKER_CONNECTIONS|1024|Nginx max connections|
|WORKER_USERNAME|nginx|Run nginx as this user|
|LISTFORMAT|json|How we return directory listings|
|MIN_DELETE_DEPTH|0|Minimum depth where user can delete files or folders|
|SENDFILE|on|Nginx sendfile enabled?|
|TCP_NOPUSH|off|Nginx tcp_nopush?|
|TCP_NODELAY|on|Nginx tcp_nodelay?|
|TRUSTED_SUBNET|all|Only allow write from this subnet (CIDR)|
|LISTENPORT|80|Port to listen to|
|LDAP_PROTOCOL|ldaps|Can also be set to unencrypted ldap|
|LDAP_PORT|636|Which port to connect to|
|LDAP_SERVER||Server address|
|LDAP_DN||The domain path to search, e.g. DC=foobar,DC=com|
|LDAP_DOMAIN||Short hand domain name, e.g. mycompany|
|LDAP_BIND_USER||Which username we will bind with|
|LDAP_BIND_PASSWORD||Password for the bind user|
|LDAP_FILTER|`sAMAccountName?sub?(objectClass=person)`|Filter expression (use `uid?sub?(objectClass=inetOrgPerson)` for the OpenLDAP server)|
|LDAP_AUTH_MESSAGE|LDAP Required|Authentication message|
|LDAP_OPEN_METHODS|GET PROFIND OPTIONS|Methods accessible without authentication or the special value "none"|
|USE_PERFLOG|0|Also logs to /log/access.log if set to 1, useful for [exporting](https://www.martin-helmich.de/en/blog/monitoring-nginx.html)|
|SSL|off|Set to on, to use SSL over the listenport|
|CERTIFICATE|/etc/certs.d/bad.pem|Use this to map in a proper certificate|
|CERTIFICATE_KEY|/etc/certs.d/bad.key|Use this to map in a proper key|
|PGID||for for GroupID - see below for explanation|
|PUID||for for UserID - see below for explanation|


## User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" <sup>TM</sup>.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```


# Resources

* https://nginx.org/en/docs/http/ngx_http_dav_module.html
* https://thoughts.t37.net/nginx-optimization-understanding-sendfile-tcp-nodelay-and-tcp-nopush-c55cdd276765
* https://www.nginx.com/resources/admin-guide/serving-static-content/
* https://github.com/kvspb/nginx-auth-ldap
* https://www.martin-helmich.de/en/blog/monitoring-nginx.html

# Alternatives

* https://github.com/jgeusebroek/docker-webdav
