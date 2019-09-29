#!/bin/bash

# environment variable
source $1

# clean
rm -f /conf/elements.conf.with.assets

# command alias
ec="elements-cli ${ELEMENTS_MODE}"
ed="elementsd    ${ELEMENTS_MODE}"

# utility function
function wait_for_start() {
  WAITING=true
  while ${WAITING}
  do
    WAITING=false
    $ec getwalletinfo > /dev/null 2>&1 || WAITING=true
    if ${WAITING}; then
      sleep 1
    fi
  done
}

function wait_for_stop() {
  STATUS=$(pgrep elementsd)
  while [ "${STATUS}" != "" ]
  do
    STATUS=$(pgrep elementsd)
    sleep 1
  done
}

# startup elementsd for issue custom asset
$ed -daemon

# wait for startup done
wait_for_start

# issue asset & add asset label to conf
$ec generate 100

# asset[1]: ABC coin
ASSET=$($ec issueasset 20000000 200)
ABC=$(echo $ASSET | sed -r 's/.*"asset": "([0-9a-z]*)".*/\1/')
echo "assetdir=$ABC:ABC" >> ${ELEMENTS_CONF_DIR}/elements.conf

# asset[2]: XYZ coin
ASSET=$($ec issueasset 10000000 100)
XYZ=$(echo $ASSET | sed -r 's/.*"asset": "([0-9a-z]*)".*/\1/')
echo "assetdir=$XYZ:XYZ" >> ${ELEMENTS_CONF_DIR}/elements.conf

# copy for other elementsd containers
cp ${ELEMENTS_CONF_DIR}/elements.conf /conf/elements.conf.with.assets

# stop elementsd
$ec stop
wait_for_stop

# startup with issued assets
$ed -daemon -port=10001 
wait_for_start

# for docker container
tail -f /dev/null
