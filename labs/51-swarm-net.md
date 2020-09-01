# Docker Swarm

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

## Create an Overlay Network

Create an overlay virtual network, create a container attached to it, and inspect interfaces in the container

```
docker network create --driver=overlay --subnet=192.168.1.0/24 \
  --attachable ov0
docker run --rm --network ov0 busybox ifconfig
```

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
docker run --rm --network ov0 -itd busybox
sudo ip netns
sudo ip netns exec <ns> ip address
```

Inspect the overlay network namespace:

```
sudo ip netns exec <id> brctl show
sudo ip netns exec <id> ip address 
sudo ip netns exec <id> bridge fdb show dev vxlan0 
sudo ip netns exec <id> ip neighbor
sudo ip netns exec <id> ip -d link show vxlan0
```

## Docker swarm node load balancing

Create a Docker service and inspect NAT tables and related Docker networks.

```
docker service create --name websvc \
  --network ov0 --publish 4000:80 \
  --replicas 3 webapp
docker ps
docker inspect <id>

sudo iptables -t nat -S
docker network inspect ingress
docker network inspect docker_gwbridge
docker network inspect ov0
```

Explore the Docker service load balancing setup:

```
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
sudo ip netns exec <id> ip address show
sudo ip netns exec <id> iptables -t nat -S
```
 