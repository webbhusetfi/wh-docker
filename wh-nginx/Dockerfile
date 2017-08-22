FROM debian:jessie-slim

MAINTAINER Kim Wistbacka <kim.wistbacka@gmail.com>

RUN echo "deb http://httpredir.debian.org/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get -t jessie-backports install --no-install-recommends --no-install-suggests -y nginx-full gettext-base \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    \
    && cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.template \
    && sed -i \
        -e 's/user www-data/user ${USER_ID} ${GROUP_ID}/' \
        -e 's/worker_processes .*$/worker_processes ${NGINX_WORKER_PROCESSES};/' \
        -e 's/worker_connections .*$/worker_connections ${NGINX_WORKER_CONNECTIONS};/' \
        -e 's/\(# \)\?multi_accept .*$/multi_accept ${NGINX_MULTI_ACCEPT};/' \
        -e 's|/etc/nginx/sites-enabled/\*|/var/www/${HOSTNAME}/conf/nginx.conf|' \
        "/etc/nginx/nginx.conf.template" \
    && rm /etc/nginx/sites-enabled/default \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    \
    && echo '#!/bin/bash' > /usr/local/sbin/run-nginx.sh \
    && echo 'if [ ! -d /var/www/${HOSTNAME}/conf ]; then' >> /usr/local/sbin/run-nginx.sh \
    && echo '    mkdir -p /var/www/${HOSTNAME}/conf' >> /usr/local/sbin/run-nginx.sh \
    && echo 'fi' >> /usr/local/sbin/run-nginx.sh \
    && echo 'if [ ! -f /var/www/${HOSTNAME}/conf/nginx.conf ]; then' >> /usr/local/sbin/run-nginx.sh \
    && echo '    touch /var/www/${HOSTNAME}/conf/nginx.conf' >> /usr/local/sbin/run-nginx.sh \
    && echo 'fi' >> /usr/local/sbin/run-nginx.sh \
    && echo 'use="\$HOSTNAME \$USER_ID \$GROUP_ID \$NGINX_WORKER_PROCESSES \$NGINX_WORKER_CONNECTIONS \$NGINX_MULTI_ACCEPT"' >> /usr/local/sbin/run-nginx.sh \
    && echo 'envsubst "$use" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf' >> /usr/local/sbin/run-nginx.sh \
    && echo 'exec nginx -g "daemon off;"' >> /usr/local/sbin/run-nginx.sh \
    && chmod +x /usr/local/sbin/run-nginx.sh

ENV HOSTNAME=default \
    USER_ID=www-data \
    GROUP_ID=www-data \
    \
    NGINX_WORKER_PROCESSES=auto \
    NGINX_WORKER_CONNECTIONS=1024 \
    NGINX_MULTI_ACCEPT=on

EXPOSE 80 443
STOPSIGNAL SIGQUIT
CMD ["run-nginx.sh"]
