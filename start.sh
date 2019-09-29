#!/bin/bash

set -e

elements_ver=$(grep "ELEMENTS_VER" .env | sed -e 's/.*=//')
cp .env container/elements/script/env.${elements_ver}

nwcnt=$(docker network ls | grep "regtest-network" | wc -l)
if [ "$nwcnt" == "0" ] ; then
  docker network create --driver=bridge --subnet=172.16.0.0/16 regtest-network
fi

compose_file=docker-compose.yml
docker-compose -f $compose_file stop
docker-compose -f $compose_file rm -f
docker-compose -f $compose_file up -d --force-recreate --remove-orphans

# docker logs jupyter 2>&1 | grep "token" | grep "NotebookApp" | sed -r 's/.*\?(.*)/\1/'
