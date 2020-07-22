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

```
docker network create --driver=overlay --subnet=192.168.1.0/24 \
  --attachable ov0
docker run --rm --network ov0 busybox ifconfig

docker network ls
brctl

sudo ip netns

cd /var/run
sudo ln -s /var/run/docker/netns /var/run
sudo ip netns

docker run --rm --network ov0 -itd busybox
sudo ip netns
sudo ip netns exec <ns> ip address
```

## Docker swarm node load balancing

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

## Start a swarm service

```
docker tag webapp ipspace/demo:webapp
docker login
docker push ipspace/demo:webapp

docker service create --name websvc \
  --network ov0 --publish 4000:80 \
  --replicas 3 ipspace/demo:webapp

docker ps
docker node ps

docker node ps $(docker node ls -q)

docker service scale websvc=5

docker node ps $(docker node ls -q)
```

## Docker Compose

    cd /vagrant/websvc
    docker swarm init
    docker stack deploy -c docker-compose.yml websvc
    docker stack services websvc
    docker stack ps services

From docker host execute `curl http://127.0.0.1:3000/`