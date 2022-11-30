#!/bin/bash
set -e
set -x

SOURCE=ubuntu@hetzner.molnix.com
SOURCEPORT=46051
DBSOURCEPORT=46052
PRIVATEKEY="" #If you use different key for molnix. Ex: -i /Users/v/molnix
TARGETDIR=".." # Without trailing slash
INCLUDESITES="sa.webbhuset.fi demo.webbhuset.fi" # Add any sites you want to always have at hand here, or run the script with sites as arguments to fetch more
MORESITES="$@"

mkdir -p $TARGETDIR/webbhuset.fi/sites $TARGETDIR/lib

cd ${TARGETDIR}/lib
for REPO in DS DS-custom DS-uni Katalogen Kontoret registry-backend registry-client; do
  if [[ ! -e "$REPO" ]]; then
    git clone git@github.com:webbhusetfi/${REPO}.git
  else
    cd "$REPO"
#    git pull
    cd ..
  fi
done

rsync -az -e "ssh $PRIVATEKEY -p $SOURCEPORT" --progress --delete --rsync-path="sudo rsync" ${SOURCE}:/var/www/webbhuset.fi/conf ${TARGETDIR}/webbhuset.fi --exclude=conf/cron
rsync -az -e "ssh $PRIVATEKEY -p $SOURCEPORT" --progress --delete ${SOURCE}:/var/www/webbhuset.fi/sites/.nginx.map ${TARGETDIR}/webbhuset.fi/sites/.nginx.map
rsync -az -e "ssh  $PRIVATEKEY -p $SOURCEPORT" --progress --delete ${SOURCE}:/var/www/lib/DS/app/config.php ${TARGETDIR}/lib/DS/app/config.php
rsync -az -e "ssh  $PRIVATEKEY -p $SOURCEPORT" --progress --delete ${SOURCE}:/var/www/lib/DS/app/googleapiprivatekey.p12 ${TARGETDIR}/lib/DS/app/googleapiprivatekey.p12

for i in $INCLUDESITES $MORESITES; do
 rsync -az -e "ssh $PRIVATEKEY -p $SOURCEPORT" --progress --delete ${SOURCE}:/var/www/webbhuset.fi/sites/${i}/ ${TARGETDIR}/webbhuset.fi/sites/${i}
done

rsync -az -e "ssh $PRIVATEKEY -p $DBSOURCEPORT" --progress --delete ${SOURCE}:~/database-wh-db.sql.gz ${TARGETDIR}/wh-docker/mysql/tmp/.

echo "Ready for building:"
echo "PATH_TO_WEBBHUSET=$(dirname $(pwd))/webbhuset.fi/ PATH_TO_LIB=$(dirname $(pwd))/lib/ docker-compose up --build"

cd $TARGETDIR
