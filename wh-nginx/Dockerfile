FROM debian:jessie-slim

MAINTAINER Kim Wistbacka <kim.wistbacka@gmail.com>

ARG HOSTNAME="host"

RUN echo "deb http://httpredir.debian.org/debian jessie-backports main contrib non-free" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get -t jessie-backports install --no-install-recommends --no-install-suggests -y nginx-full gettext-base \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/worker_processes .*$/worker_processes  auto;/' "/etc/nginx/nginx.conf" \
    && echo 'include /var/www/'"$HOSTNAME"'/conf/nginx.conf;' > /etc/nginx/conf.d/default.conf \
    && rm /etc/nginx/sites-enabled/default \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
