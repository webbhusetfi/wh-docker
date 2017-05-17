# WH Docker files

# Build

```sh
docker build -t wh-apache wh-apache
```
```sh
docker build -t wh-nginx wh-nginx
```
```sh
docker build -t wh-php wh-php
```

# Run

```sh
docker run --net=host --restart=unless-stopped -v /host/path/to/www:/var/www -d wh-apache
```
```sh
docker run --net=host --restart=unless-stopped -v /host/path/to/www:/var/www -d wh-nginx
```
```sh
docker run --net=host --restart=unless-stopped -v /host/path/to/www:/var/www -d wh-php
```
