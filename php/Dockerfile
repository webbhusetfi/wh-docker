FROM debian:stretch-slim

MAINTAINER Kim Wistbacka <kim.wistbacka@gmail.com>

ARG PHP_VERSION="7.2"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y --no-install-recommends -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install \
        apt-transport-https \
        ca-certificates \
        gnupg \
        curl \
    && echo "deb http://httpredir.debian.org/debian stretch-backports main contrib non-free" >> /etc/apt/sources.list \
    && curl -fSL "https://packages.sury.org/php/apt.gpg" -o "/etc/apt/trusted.gpg.d/php.gpg" \
    && echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && DEBIAN_FRONTEND=noninteractive apt-get -q -y  --no-install-recommends -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install \
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
        mariadb-client \
        msmtp \
        rsync \
        openssh-client \
        nodejs \
        locales \
    && apt-get -t stretch-backports install --no-install-recommends --no-install-suggests -y certbot \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 2>/dev/null \
    \
    && echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen \
    && echo 'sv_FI.UTF-8 UTF-8' >> /etc/locale.gen \
    && echo 'fi_FI.UTF-8 UTF-8' >> /etc/locale.gen \
    && locale-gen \
    \
    && npm install --unsafe-perm -g node-sass \
    && chown -R nobody:www-data /usr/lib/node_modules/node-sass \
    \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    \
    && mkdir /run/php \
    && sed -i -e 's|^;\{0,1\}error_log =.*$|error_log = /proc/self/fd/2|' "/etc/php/${PHP_VERSION}/fpm/php-fpm.conf" \
    && echo 'include=/var/www/${HOSTNAME}/conf/php/php-fpm.conf' >> "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf" \
    \
    && echo '#!/bin/bash' > /usr/local/sbin/run-php-fpm.sh \
    && echo 'if [ ! -d /var/www/${HOSTNAME}/conf/php ]; then' >> /usr/local/sbin/run-php-fpm.sh \
    && echo '    mkdir -p /var/www/${HOSTNAME}/conf/php' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'fi' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'if [ ! -s /var/www/${HOSTNAME}/conf/php/php-fpm.conf ]; then' >> /usr/local/sbin/run-php-fpm.sh \
    && echo '    cat <<EOT >> /var/www/${HOSTNAME}/conf/php/php-fpm.conf' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'user = ${USER_ID}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'group = ${GROUP_ID}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo '' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'listen = ${FPM_HOST}:${FPM_PORT}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'listen.allowed_clients = ${FPM_LISTEN_ALLOWED_CLIENTS}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'catch_workers_output = ${FPM_CATCH_WORKER_OUTPUT}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'security.limit_extensions = ${FPM_SECURITY_LIMIT_EXTENSIONS}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo '' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'pm = ${FPM_PM}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'pm.start_servers = ${FPM_PM_START_SERVERS}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'pm.max_children = ${FPM_PM_MAX_CHILDREN}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'pm.min_spare_servers = ${FPM_PM_MIN_SPARE_SERVERS}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'pm.max_spare_servers = ${FPM_PM_MAX_SPARE_SERVERS}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'pm.max_requests = ${FPM_PM_MAX_REQUESTS}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'pm.status_path = ${FPM_PM_STATUS_PATH}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo '' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'php_admin_value[memory_limit] = ${PHP_MEMORY_LIMIT}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'php_admin_value[max_execution_time] = ${PHP_MAX_EXECUTION_TIME}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'php_admin_value[max_input_time] = ${PHP_MAX_INPUT_TIME}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'php_admin_value[post_max_size] = ${PHP_POST_MAX_SIZE}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'php_admin_value[upload_max_filesize] = ${PHP_UPLOAD_MAX_FILESIZE}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo '' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'php_admin_flag[display_errors] = ${PHP_DISPLAY_ERRORS}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'php_admin_flag[log_errors] = ${PHP_LOG_ERRORS}' >> /usr/local/sbin/run-php-fpm.sh \
    && echo '' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'php_admin_value[sendmail_path] = /usr/bin/msmtp -C /var/www/${HOSTNAME}/conf/php/msmtprc -t -i' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'EOT' >> /usr/local/sbin/run-php-fpm.sh \
    && echo '' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'fi' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'if [ ! -f /var/www/${HOSTNAME}/conf/php/msmtprc ]; then' >> /usr/local/sbin/run-php-fpm.sh \
    && echo '    touch /var/www/${HOSTNAME}/conf/php/msmtprc' >> /usr/local/sbin/run-php-fpm.sh \
    && echo 'fi' >> /usr/local/sbin/run-php-fpm.sh \
    && echo "exec php-fpm${PHP_VERSION} -F" >> /usr/local/sbin/run-php-fpm.sh \
    && chmod +x /usr/local/sbin/run-php-fpm.sh

ENV HOSTNAME=default \
    USER_ID=www-data \
    GROUP_ID=www-data \
    \
    FPM_HOST=0.0.0.0 \
    FPM_PORT=9000 \
    FPM_LISTEN_ALLOWED_CLIENTS= \
    FPM_CATCH_WORKER_OUTPUT=yes \
    FPM_SECURITY_LIMIT_EXTENSIONS=.php \
    \
    FPM_PM=dynamic \
    FPM_PM_START_SERVERS=1 \
    FPM_PM_MAX_CHILDREN=5 \
    FPM_PM_MIN_SPARE_SERVERS=1 \
    FPM_PM_MAX_SPARE_SERVERS=2 \
    FPM_PM_MAX_REQUESTS=1000 \
    FPM_PM_STATUS_PATH=/fpm-status \
    \
    PHP_MAX_EXECUTION_TIME=30 \
    PHP_MAX_INPUT_TIME=60 \
    PHP_MEMORY_LIMIT=64M \
    PHP_POST_MAX_SIZE=10M \
    PHP_UPLOAD_MAX_FILESIZE=10M \
    \
    PHP_DISPLAY_ERRORS=Off \
    PHP_LOG_ERRORS=On \
    \
    COMPOSER_ALLOW_SUPERUSER=1

EXPOSE ${FPM_PORT}
CMD ["run-php-fpm.sh"]
