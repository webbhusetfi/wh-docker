#!/bin/bash
set -e

SOURCE=ubuntu@hetzner.molnix.com
SOURCEPORT=46051
TARGETDIR="../webbhuset.fi" # Without trailing slash
INCLUDESITES="sa.webbhuset.fi demo.webbhuset.fi" # Add any sites you want to always have at hand here, or run the script with sites as arguments to fetch more
MORESITES="$@"

mkdir -p $TARGETDIR/sites

rsync -az -e "ssh -p $SOURCEPORT" --progress --delete ${SOURCE}:/var/www/webbhuset.fi/conf ${TARGETDIR} --exclude=conf/ssl --exclude=conf/cron
rsync -az -e "ssh -p $SOURCEPORT" --progress --delete ${SOURCE}:/var/www/webbhuset.fi/sites/.nginx.map ${TARGETDIR}/sites/.nginx.map

for i in $INCLUDESITES $MORESITES; do
   rsync -az -e "ssh -p $SOURCEPORT" --progress --delete ${SOURCE}:/var/www/webbhuset.fi/sites/${i}/ ${TARGETDIR}/sites/${i}
done
