#!/bin/bash
#
echo "Cleanup docker environment"
#
if [ "$(docker ps -q)" ]; then
  echo "... killing running containers"
  docker kill $(docker ps -q)
fi
if [ "$(docker ps -aq)" ]; then
  echo "... removing stopped containers"
  docker rm $(docker ps -aq)
fi
if [ "$(docker volume ls -q)" ]; then
  echo "... removing volumes"
  docker volume prune --force
fi
