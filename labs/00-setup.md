# Set up your Docker environment

* Install vagrant and virtualbox
* In the repository's root directory execute `vagrant up manager` (for a single node setup)
  or `vagrant up` to create a manager and a Swarm worker node
* Log into the Docker VM with `vagrant ssh manager`
* If you want to change the prompt execute `. /vagrant/.bash_profile`

## Cleanup

You might need to clean up from a previous demo. Leave swarm and remove all stale
containers and unused images

    docker swarm leave --force
    docker system prune

Alternative:

    docker rm $(docker ps -qa --no-trunc --filter "status=exited")
    docker rm $(docker ps -qa --no-trunc --filter "status=created")

See also [docker cleanup](https://gist.github.com/bastman/5b57ddb3c11942094f8d0a97d461b430)

## Setup images

Pull images to make the labs run faster. On manager:

    docker pull perl:latest
    docker pull python:2.7-slim
    docker pull python:3-slim
    docker pull ubuntu:16.04
    docker pull ubuntu:latest

On worker:

    docker pull python:2.7-slim

Remove busybox image (for first demo):

    docker rmi busybox

Set up Docker Compose for NetBox and pull down images

    git clone https://github.com/netbox-community/netbox-docker.git
    cd netbox-docker
    docker-compose pull

Edit docker-compose.yml, change exposed port for nginx (from 8080 to "8080:8080")

Set up Ansible image

    docker build /vagrant/app/ansible -t ansible
