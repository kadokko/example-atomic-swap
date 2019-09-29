#!/bin/bash

set -e

elements="elements1 elements2 elements3"

compose_file=docker-compose.yml
docker-compose -f $compose_file stop  $elements
docker-compose -f $compose_file rm -f $elements
docker-compose -f $compose_file up -d --force-recreate --remove-orphans $elements
