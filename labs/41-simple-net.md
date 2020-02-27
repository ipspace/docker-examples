# Single Host Docker Networking

## Overview

Show default networks with `docker network ls`

Show installed plugins with `docker plugin ls`

## Run containers without services

This section demonstrates Docker networking for containers
without service ports exposed in the container image.

Before starting examples in this section, start `webapp`
container on the worker1 node.

### Default Docker bridge

* Start two `busybox` images
* inspect /etc/hosts, /etc/resolv.conf and ifconfig
* show mounts with `mount|grep etc`
* Check that the busybox images can ping each other
* Check the IP address used for external connectivity

    wget -q -O - http://192.168.10.3

Show dormant containers and kill them.

### Using a custom network

    docker network create --driver=bridge --subnet=192.168.99.0/24 br0
    docker run -itd --name c1 --network=br0 busybox
    docker run -itd --name c3 busybox
    docker run -it --name c2 --network=br0 busybox

Explore DNS and connectivity between C1 and C2.

    docker run -it --name c3 busybox

Explore DNS and connectivity between C3 and C1/C2

    docker stop $(docker ps -aq); docker system prune

### Custom network with container isolation

    docker network create --driver=bridge --subnet=192.168.99.0/24 \
      -o "com.docker.network.bridge.enable_icc=false" br0
    docker run -itd --name c1 --network=br0 busybox
    docker run -itd --name c3 busybox
    docker run -it --name c2 --network=br0 busybox

    docker stop $(docker ps -aq); docker system prune

### Isolated network

    docker network create --driver=bridge --subnet=192.168.99.0/24 \
      --internal internal
    docker run -itd --name c1 --network=internal busybox
    docker run -itd --name c3 busybox
    docker run -it --name c2 --network=internal busybox

### Container with no network

    docker run -itd --rm --network=none busybox

### Run a service

    docker network create --driver=bridge --subnet=192.168.0.0/24 br0
    docker run -d --network=br0 --name app webapp
    docker container inspect app
    docker container inspect app|jq .[0].State.Status
    docker container inspect app|jq .[0].NetworkSettings.Networks.br0.IPAddress
    curl http://ip-address/

    docker run -it busybox
    wget -qO- http://192.168.0.2
    docker run -it --network br0 busybox
    wget -qO- http://192.168.0.2
    wget -qO- http://app

Restart the service with exposed port

    docker rm -f app
    docker run -p 4000:80 -d --name app webapp
    docker run -it busybox
    wget -q -O - http://172.17.0.1:4000/

Restart the service with exposed port

    docker rm -f app
    docker run -p 192.168.0.1:4000:80 -d --name app webapp
    docker run -it busybox
    wget -q -O - http://192.168.0.1:4000/
