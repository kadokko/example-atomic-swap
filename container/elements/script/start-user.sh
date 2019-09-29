#!/bin/bash

sleep 5

# environment variable
source $1

# command alias
ed="elementsd ${ELEMENTS_MODE}"

# copy for other elementsd containers
while :
do
  if [ -e "/conf/elements.conf.with.assets" ]; then
    cp -f /conf/elements.conf.with.assets ${ELEMENTS_CONF_DIR}/elements.conf
    break
  fi
  sleep 1
done

# startup with labeled assets
$ed -daemon -connect=elements1:10001
tail -f /dev/null
