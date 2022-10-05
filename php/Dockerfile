FROM php:7.4-fpm

WORKDIR /var/www

RUN rm /var/lib/apt/lists/* -vrf && \
    apt-get clean && apt-get update

# RUN pecl install xdebug \
#     && docker-php-ext-enable xdebug

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    g++ \
    apt-utils \
    libpcre3-dev \
    zlib1g-dev \
    libicu-dev \
    alien \
    libzip-dev \
    zip \
    git \
    libjpeg-dev \
    libpng-dev \
    libxml2-dev \
    libfreetype6-dev \
    libmcrypt-dev \
    libssl-dev \
    supervisor \
    tzdata \
    libmagickwand-dev \
    libmagickcore-dev \
    wget \
    && echo "upload_max_filesize = 8M" > /usr/local/etc/php/conf.d/upload.ini \
    && docker-php-ext-install exif intl pdo_mysql bcmath pcntl soap \
    && docker-php-ext-configure zip \
    && docker-php-ext-configure gd --with-jpeg --with-freetype &&  \
    docker-php-ext-install gd zip


## install composer inside container
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

# RUN sed -i 's/127.0.0.1:9000/0.0.0.0:9000/g' /usr/local/etc/php-fpm.d/www.conf

RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

RUN chown www:www /var/www
USER www

# RUN echo "include=/var/www/webbhuset.fi/conf/php-fpm.conf;" >> /etc/php/*/fpm/pool.d/www.conf 

EXPOSE 9000
CMD ["php-fpm"]