# Single Host Docker Networking

Preparation:

```
docker swarm leave --force
docker system prune --force
```

Start `webapp` container on the `worker1` node

```
cd /vagrant/app/
docker build -t webapp websvc
docker run --rm -d -p 3000:80 --name web webapp
```

## Intro: containers with services on default Docker bridge

This section demonstrates Docker networking for containers using default Docker bridge without service ports exposed in the container image.

Show default networks with `docker network ls`
Show installed plugins with `docker plugin ls`

* Start two `busybox` images

```
docker run --name C1 --rm -it busybox
```

* inspect interfaces with `ifconfig`
* inspect routing table with `ip route`
* inspect /etc/hosts and /etc/resolv.conf
* show mounts with `mount|grep etc`
* Check that the busybox images can ping each other and the Linux host
* Check the IP address used for external connectivity

```
wget -q -O - http://192.168.33.3:3000
```


## Using a custom bridge network

```
docker network create --driver=bridge --subnet=192.168.99.0/24 br0
docker run -itd --rm --name c1 --network=br0 busybox
docker run -itd --rm --name c3 busybox
docker inspect c1 c3|jq -f /vagrant/filter/ipaddr
docker run -it --rm --name c2 --network=br0 busybox
```

Explore DNS and connectivity toward C1 and C3.

```
docker run -it --name c4 --rm busybox
```

Explore DNS and connectivity toward C1 and C3.

```
docker stop $(docker ps -aq); docker system prune --force
```

## Custom networks with container isolation

```
docker network create --driver=bridge --subnet=192.168.99.0/24 \
  -o "com.docker.network.bridge.enable_icc=false" br0
docker run -itd --name c1 --network=br0 busybox
docker run -itd --name c3 busybox
docker run -it --name c2 --network=br0 busybox

docker stop $(docker ps -aq); docker system prune --force
```

### Isolated network

```
docker network create --driver=bridge --subnet=192.168.99.0/24 \
  --internal internal
docker run -itd --name c1 --network=internal busybox
docker run -itd --name c3 busybox
docker run -it --name c2 --network=internal busybox
```

### Special network types

Container without a network

```
docker run -itd --rm --network=none busybox
```

Container within host namespace

```
docker run -itd --rm --network=host busybox
ifconfig
ip route
```

### Run a service

Start the service and inspect service container

```
docker network create --driver=bridge --subnet=192.168.0.0/24 br0
docker run -d --network=br0 --name app webapp
docker container inspect app
docker container inspect app|jq .[0].State.Status
docker container inspect app|jq .[0].NetworkSettings.Networks.br0.IPAddress
curl http://ip-address/
```

Use service from other containers

```
docker run -it busybox
wget -qO- http://192.168.0.2
docker run -it --network br0 busybox
wget -qO- http://192.168.0.2
wget -qO- http://app
```

Restart the service with exposed port

```
docker rm -f app
docker run -p 4000:80 -d --name app webapp
docker run -it busybox
wget -q -O - http://172.17.0.1:4000/
```

Restart the service with exposed port bound to a single IP address

```
docker rm -f app
docker run -p 192.168.0.1:4000:80 -d --name app webapp
docker run -it busybox
wget -q -O - http://192.168.0.1:4000/
```
