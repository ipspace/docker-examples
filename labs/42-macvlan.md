# MACVLAN and IPVLAN networking

We'll create MACVLAN and IPVLAN interfaces in the 192.168.33.0/24 subnet
(eth1 interface). First we have to set the interface to promiscuous
mode (both in VirtualBox and in Ubuntu), then we can create a MACVLAN
network

```
sudo ip link set eth1 promisc on
docker network create --driver=macvlan \
  --subnet=192.168.33.0/24 \
  --ip-range=192.168.33.32/28 \
  --gateway=192.168.33.1 \
  -o parent=eth1 mv1
```

After creating the network, run a busybox instance and try pinging the
default gateway (VirtualBox host), host IP (should fail), and other IP
addresses on the same segment (worker1 node).

```
docker run --rm --network mv1 -it busybox
ip address
<try pinging around>
```

Run a second busybox container, show that the MAC addresses differ. Log into worker host and inspect the ARP cache

## IPVLAN example

Replace MACVLAN with IPVLAN driver, repeat the previous tests, show that the ARP cache on `worker1` contains a single MAC address (also, **ip address** displays the same MAC address in all containers).

```
docker network create --driver=ipvlan \
  --subnet=192.168.33.0/24 \
  --ip-range=192.168.33.48/28 \
  -o parent=eth1 -o ipvlan_mode=l2 mv2

docker run --rm --network mv2 -it busybox
```
