# Docker Swarm

NOTE: This file contains the commands used to generate the printouts in the
*Docker Swarm Networking* part of
*[Docker Networking Deep Dive](https://www.ipspace.net/Docker_Networking_Deep_Dive)*
webinar. Watch the webinar for full explanation of command printouts and their meaning.

Set up swarm on manager node

```
docker system prune -f
docker swarm leave -f
docker swarm init --advertise-addr 192.168.33.2
```

Set up swarm on worker nodes

```
docker swarm leave -f
docker swarm join --token ... (copied from manager)
```

## Default Docker Swarm Networking

Create an overlay virtual network, create a container attached to it, and inspect interfaces in the container

```
docker network create --driver=overlay --subnet=192.168.1.0/24 \
  --attachable ov0
docker run --rm --network ov0 busybox ifconfig
```

Start a background Alpine container (to keep terminal window free) and use **docker inspect** to find out its configuration.

```
docker run -itd --rm --network ov0 --name test alpine
docker inspect test
docker network inspect docker_gwbridge
```

Disconnect the test container from **docker_gwbridge**

```
docker network disconnect docker_gwbridge test
docker inspect test
docker network inspect docker_gwbridge
```

## Swarm Overlay Networks

Inspect Docker networks and related Linux bridges. You cannot see overlay networks as Linux bridges.

```
docker network ls
brctl
```

Inspect default network namespaces. You cannot see Docker namespaces. Link Docker directory to the default namespaces directory and try again

```
sudo ip netns
cd /var/run
sudo ln -s /var/run/docker/netns /var/run
sudo ip netns
```

Create a daemon container connected to an overlay virtual network and inspect Docker namespaces.

```
sudo ln -s /var/run/docker/netns /var/run
sudo ip netns
sudo ip netns exec <ns> brctl show
```

Instantiate a container and explore the overlay virtual network namespace:

```
docker run -itd --rm --network ov0 --name test alpine
sudo ip netns
docker network ls
sudo ip netns exec <ns> brctl show
sudo ip netns exec <ns> ip address
```

Deploy another Alpine container on a worker node. Explore VXLAN interface parameters

```
sudo ip netns exec <ns> bridge fdb show dev vxlan0
sudo ip netns exec <ns> ip neighbor
sudo ip netns exec <ns> ip -d link show vxlan0
```

## Publishing a port from a standalone container

Run a container with a published port (using Alpine image to be able to execute **bash** commands)

```
docker run -itd --rm --network ov0 --name test -p 8080:80 alpine
```

Inspect IP address within the container and host NAT table:

```
sudo iptables -t nat -S
docker exec test ifconfig
```

## Load balancing in Docker Swarm

Create a multi-instance service

```
docker service create --name websvc \
  --network ov0 --publish 8080:80 \
  --replicas 3 webapp
docker service ls
docker service ps websvc
docker ps
docker inspect <id>
```

Inspect containers attached to **docker_gwbridge**

```
docker ps
sudo ip netns <id>
sudo ip netns exec <id> ip address show
docker network inspect docker_gwbridge
```

Inspect NAT table to find published service port

```
sudo iptables -t nat -S
```

Inspect iptables and IPVS setup in **ingress** namespace:

```
sudo ip netns exec ingress_sbox ip address
sudo ip netns exec ingress_sbox iptables -t nat -S
sudo ip netns exec ingress_sbox ipvsadm -ln
sudo ip netns exec ingress_sbox iptables -t mangle -S
```

Explore the final step (destination port remapping):

* Find container namespace
* Display interfaces in container namespace
* Display **iptables** in container namespace

```
sudo ip netns
sudo ip netns exec <id> ip address
sudo ip netns exec <id> iptables -t nat -S
```
