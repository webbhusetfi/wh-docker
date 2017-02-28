# WH Docker files

# Build

$ docker build -t wh-apache wh-apache
$ docker build -t wh-php wh-php

# Run

$ docker run --net=host --restart=unless-stopped -v /host/path/to/www:/var/www -d wh-apache
$ docker run --net=host --restart=unless-stopped -v /host/path/to/www:/var/www -d wh-php
