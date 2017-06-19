FROM debian:jessie-slim

MAINTAINER Kim Wistbacka <kim.wistbacka@gmail.com>

ARG HOSTNAME="host"
ARG PHP_VERSION="7.1"
ARG PHP_USER_ID="1000"
ARG PHP_GROUP_ID="1000"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y --no-install-recommends -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install \
        apt-transport-https \
        ca-certificates \
        curl \
    && curl -fSL "https://packages.sury.org/php/apt.gpg" -o "/etc/apt/trusted.gpg.d/php.gpg" \
    && echo "deb https://packages.sury.org/php/ jessie main" > /etc/apt/sources.list.d/php.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y  --no-install-recommends -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install \
        mariadb-client \
        msmtp \
        rsync \
        openssh-client \
        "php${PHP_VERSION}" \
        "php${PHP_VERSION}-curl" \
        "php${PHP_VERSION}-fpm" \
        "php${PHP_VERSION}-gd" \
        "php${PHP_VERSION}-mbstring" \
        "php${PHP_VERSION}-mysql" \
        "php${PHP_VERSION}-soap" \
        "php${PHP_VERSION}-xml" \
        "php${PHP_VERSION}-zip" \
        php-memcached \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 2>/dev/null \
    \
    && mkdir /run/php \
    && sed -i \
            -e 's|^;\{0,1\}sendmail_path =.*$|sendmail_path = "/usr/bin/msmtp -C /var/www/'"$HOSTNAME"'/conf/msmtprc -t"|' \
            -e 's|^;\{0,1\}max_execution_time =.*$|max_execution_time = ${PHP_MAX_EXECUTION_TIME}|' \
            -e 's|^;\{0,1\}max_input_time =.*$|max_input_time = ${PHP_MAX_INPUT_TIME}|' \
            -e 's|^;\{0,1\}memory_limit =.*$|memory_limit = ${PHP_MEMORY_LIMIT}|' \
            -e 's|^;\{0,1\}post_max_size =.*$|post_max_size = ${PHP_POST_MAX_SIZE}|' \
            -e 's|^;\{0,1\}upload_max_filesize =.*$|upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}|' \
            "/etc/php/${PHP_VERSION}/fpm/php.ini" \
    && sed -i \
            -e 's|^;\{0,1\}error_log =.*$|error_log = /proc/self/fd/2|' \
            "/etc/php/${PHP_VERSION}/fpm/php-fpm.conf" \
    && sed -i \
            -e 's/^;\{0,1\}catch_workers_output =.*$/catch_workers_output = yes/' \
            -e 's/^;\{0,1\}security\.limit_extensions =.*$/security.limit_extensions = .php/' \
            -e 's/^;\{0,1\}listen =.*$/listen = ${FPM_HOST}:${FPM_PORT}/' \
            -e 's/^;\{0,1\}pm =.*$/pm = ${FPM_PM}/' \
            -e 's/^;\{0,1\}pm.max_children =.*$/pm.max_children = ${FPM_PM_MAX_CHILDREN}/' \
            -e 's/^;\{0,1\}pm.start_servers =.*$/pm.start_servers = ${FPM_PM_START_SERVERS}/' \
            -e 's/^;\{0,1\}pm.min_spare_servers =.*$/pm.min_spare_servers = ${FPM_PM_MIN_SPARE_SERVERS}/' \
            -e 's/^;\{0,1\}pm.max_spare_servers =.*$/pm.max_spare_servers = ${FPM_PM_MAX_SPARE_SERVERS}/' \
            "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf" \
    && echo 'include=/var/www/'"$HOSTNAME"'/conf/php-fpm.conf' >> "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf" \
    \
    && echo '#!/bin/bash' > /usr/local/sbin/run.sh \
    && echo "rm -r /run/php/fpm.pid 2>/dev/null" >> /usr/local/sbin/run.sh \
    && echo "exec php-fpm${PHP_VERSION} -F" >> /usr/local/sbin/run.sh \
    && chmod +x /usr/local/sbin/run.sh

ENV PHP_MAX_EXECUTION_TIME=30 \
    PHP_MAX_INPUT_TIME=60 \
    PHP_MEMORY_LIMIT=64M \
    PHP_POST_MAX_SIZE=10M \
    PHP_UPLOAD_MAX_FILESIZE=10M \
    PHP_DISPLAY_ERRORS=Off \
    \
    FPM_HOST=127.0.0.1 \
    FPM_PORT=9000 \
    FPM_PM=dynamic \
    FPM_PM_MAX_CHILDREN=5 \
    FPM_PM_START_SERVERS=2 \
    FPM_PM_MIN_SPARE_SERVERS=1 \
    FPM_PM_MAX_SPARE_SERVERS=3

EXPOSE ${FPM_PORT}
CMD ["/usr/local/sbin/run.sh"]
