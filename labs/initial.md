This file contains the old demo script used in pre-2020 Docker Workshop. Do not use.

## Preparation

### Cleanup

    docker swarm leave --force
    docker system prune

Alternative:

    docker rm $(docker ps -qa --no-trunc --filter "status=exited")
    docker rm $(docker ps -qa --no-trunc --filter "status=created")

See also [docker cleanup](https://gist.github.com/bastman/5b57ddb3c11942094f8d0a97d461b430)

### Install Docker Compose

    curl -L https://github.com/docker/compose/releases/download/1.16.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

### Setup images

On manager:

    docker pull perl:5.20
    docker pull python:2.7-slim
    docker pull ubuntu:16.04

On worker:

    docker pull python:2.7-slim

### Start web server on second VM

    vagrant ssh worker1
    cd /vagrant/websvc
    docker build -t webapp .
    docker run -p 80:80 -d --name app webapp

## Namespace demos

### Process Namespaces

    $ docker run -it busybox

Start top within the container
Execute **ps aufx** within another terminal window

### Mount Point Namespaces

Execute **ls -lR** within a busybox container

Touch a file in the container, find the file in host file system with

    sudo find / -name Waldo -print

### UID Namespace

Start a new container with `docker run -it -v /:/host busybox

Execute whoami

Explore /etc/passwd, /host/etc/passwd, /host/etc/shadow

### Execute a Perl Script

    docker run -it --rm --name perl -v "$PWD":/src -w /src perl:5.20 perl hello-world.pl

Also:
* Show dormant containers with **docker container ls -a** or **docker ps -a**

### Overlay File System

* Run two busybox images
* Create a new file in each container, find it in the host file system
* Show that they don’t see each other
* Remove **/bin/tee** in a busybox image
* Show the whiteout file in top layer

Also
* Inspect layers with docker container inspect name and docker history

### Build a New Image

    cd /vagrant/websvc
    docker build -t webapp .

* Explore the image with `docker history webapp`

## Docker Networking

### Overview

Show default networks with `docker network ls`

Show installed plugins with `docker plugin ls`

### Container with no services

#### Using default Docker bridge

* Start two `busybox` images
* inspect /etc/hosts, /etc/resolv.conf and ifconfig
* show mounts with `mount|grep etc`
* Check that the busybox images can ping each other
* Check the IP address used for external connectivity

    wget -q -O - http://192.168.10.3

Show dormant containers and kill them.

#### Using a custom network

    docker network create --driver=bridge --subnet=192.168.0.0/24 br0
    docker run -itd --name c1 --network=br0 busybox
    docker run -it --name c2 --network=br0 busybox

Explore DNS and connectivity between C1 and C2.

    docker run -it --name c3 busybox

Explore DNS and connectivity between C3 and C1/C2

    docker stop $(docker ps -aq); docker system prune

#### Custom network with container isolation

    docker network create --driver=bridge --subnet=192.168.0.0/24 \
      -o "com.docker.network.bridge.enable_icc=false" br0
    docker run -itd --name c1 --network=br0 busybox
    docker run -it --name c2 --network=br0 busybox

    docker stop $(docker ps -aq); docker system prune

#### Isolated network

    docker network create --driver=bridge --subnet=192.168.0.0/24 \
      --internal internal
    docker run -itd --name c1 --network=internal busybox
    docker run -it --name c2 --network=internal busybox

#### Container with no network

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

### Docker load balancing

    docker swarm init --advertise-addr 192.168.10.2

    docker network create --driver=overlay --subnet=192.168.1.0/24 \
    --attachable ov0

    docker service create --name websvc \
      --network ov0 --publish 4000:80 \
      --replicas 3 --detach webapp

### Docker swarm

    docker tag webapp ipspace/demo:webapp
    docker login
    docker push ipspace/demo:webapp

    docker swarm join-token worker

    docker swarm join --advertise-addr 192.168.10.3 --listen-addr 192.168.10.3:2377 --token 192.168.10.2

    docker service create --name websvc \
      --network ov0 --publish 4000:80 \
      --replicas 3 --detach ipspace/demo:webapp

    docker node ps $(docker node ls -q)

    docker service scale websvc=5

    docker node ps $(docker node ls -q)

## Docker Compose

    cd /vagrant/websvc
    docker swarm init
    docker stack deploy -c docker-compose.yml websvc

From docker host execute `wget http://127.0.0.1:3000/`
