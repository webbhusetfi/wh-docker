FROM debian:jessie-slim

MAINTAINER Kim Wistbacka <kim.wistbacka@gmail.com>

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y  --no-install-recommends -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install \
        apache2-mpm-event \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 2>/dev/null \
    \
    && mkdir /var/lock/apache2 /var/run/apache2 \
    && a2dismod -f alias auth_basic authn_file authn_core autoindex dir negotiation > /dev/null \
    && a2enmod proxy_fcgi rewrite headers expires > /dev/null \
    && a2disconf charset localized-error-pages other-vhosts-access-log serve-cgi-bin > /dev/null \
    \
    && sed -i \
            -e 's/${APACHE_LOCK_DIR}/\/var\/lock\/apache2/' \
            -e 's/${APACHE_PID_FILE}/\/var\/run\/apache2\/apache2.pid/' \
            -e 's/${APACHE_RUN_USER}/${USER_ID}/' \
            -e 's/${APACHE_RUN_GROUP}/${GROUP_ID}/' \
            -e 's/^ErrorLog .*$/ErrorLog \/proc\/self\/fd\/2/' \
            -e '/^ErrorLog .*$/a CustomLog /proc/self/fd/1 combined' \
            "/etc/apache2/apache2.conf" \
    && sed -i \
            -e "s/^#ServerSignature Off$/ServerSignature Off/" \
            -e "s/^ServerSignature On$/#ServerSignature On/" \
            -e "s/^#ServerTokens Minimal$/ServerTokens Minimal/" \
            -e "s/^ServerTokens OS$/#ServerTokens OS/" \
            "/etc/apache2/conf-enabled/security.conf" \
    && sed -i \
            -e 's/^StartServers .*$/StartServers ${APACHE_START_SERVERS}/' \
            -e 's/^MinSpareThreads .*$/MinSpareThreads ${APACHE_MIN_SPARE_SERVERS}/' \
            -e 's/^MaxSpareThreads .*$/MaxSpareThreads ${APACHE_MAX_SPARE_SERVERS}/' \
            -e 's/^ThreadLimit .*$/ThreadLimit ${APACHE_THREADLIMIT}/' \
            -e 's/^ThreadsPerChild .*$/ThreadsPerChild ${APACHE_THREADS_PER_CHILD}/' \
            -e 's/^MaxRequestWorkers .*$/MaxRequestWorkers ${APACHE_MAX_REQUEST_WORKERS}/' \
            -e 's/^MaxConnectionsPerChild .*$/MaxConnectionsPerChild ${APACHE_MAX_CONNECTIONS_PER_CHILD}/' \
            "/etc/apache2/mods-enabled/mpm_event.conf" \
    \
    && echo 'SetEnvIfNoCase ^Authorization$ "(.+)" HTTP_AUTHORIZATION=$1' > /etc/apache2/sites-enabled/000-default.conf \
    && echo '<FilesMatch ".+\.ph(p[3457]?|t|tml)$">' >> /etc/apache2/sites-enabled/000-default.conf \
    && echo '    SetHandler "proxy:fcgi://${APACHE_FPM_HOST}:${APACHE_FPM_PORT}"' >> /etc/apache2/sites-enabled/000-default.conf \
    && echo '</FilesMatch>' >> /etc/apache2/sites-enabled/000-default.conf \
    && echo '<FilesMatch ".+\.phps$">' >> /etc/apache2/sites-enabled/000-default.conf \
    && echo '    Require all denied' >> /etc/apache2/sites-enabled/000-default.conf \
    && echo '</FilesMatch>' >> /etc/apache2/sites-enabled/000-default.conf \
    && echo '<FilesMatch "^\.ph(p[3457]?|t|tml|ps)$">' >> /etc/apache2/sites-enabled/000-default.conf \
    && echo '    Require all denied' >> /etc/apache2/sites-enabled/000-default.conf \
    && echo '</FilesMatch>' >> /etc/apache2/sites-enabled/000-default.conf \
    && echo 'IncludeOptional /var/www/${HOSTNAME}/conf/apache2.conf' >> /etc/apache2/sites-enabled/000-default.conf \
    \
    && echo '#!/bin/bash' > /usr/local/sbin/run.sh \
    && echo "rm -r /var/run/apache2/apache2.pid 2>/dev/null" >> /usr/local/sbin/run.sh \
    && echo "exec apache2 -D FOREGROUND" >> /usr/local/sbin/run.sh \
    && chmod +x /usr/local/sbin/run.sh

ENV HOSTNAME=default \
    USER_ID=www-data \
    GROUP_ID=www-data \
    \
    APACHE_START_SERVERS=2 \
    APACHE_MIN_SPARE_SERVERS=25 \
    APACHE_MAX_SPARE_SERVERS=75 \
    APACHE_THREADLIMIT=64 \
    APACHE_THREADS_PER_CHILD=25 \
    APACHE_MAX_REQUEST_WORKERS=150 \
    APACHE_MAX_CONNECTIONS_PER_CHILD=0 \
    \
    APACHE_FPM_HOST=wh-php \
    APACHE_FPM_PORT=9000

EXPOSE 80
CMD ["/usr/local/sbin/run.sh"]
