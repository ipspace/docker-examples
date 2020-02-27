# Getting Excited About Docker

## Launch a Busybox Image

**docker run** downloads a container image (if needed), starts the container,
and executes the specified command.

    docker run -it busybox
    docker run -it alpine
    apk add tree

Exit alpine container, rerun it...

    docker run -it alpine

Find previous container, restart it...

    docker ps -a
    docker start -i <name>

Run a tool that is not installed on your system

    docker run perl:latest perl -v
    cd /vagrant/examples
    cat hello-world.pl
    docker run -v $(pwd):/work -w /work perl:latest perl hello-world.pl
    alias perl='docker run -v $(pwd):/work -w /work perl:latest perl'
    perl -v

Create a network automation environment

    cat /vagrant/app/ansible/Dockerfile
    docker run ansible ansible-playbook --version

    cd /vagrant/examples
    docker run -v $(pwd):/work ansible ansible-playbook -v playbook.yml

Build and deploy an application

    cd /vagrant/app/websvc
    cat Dockerfile
    docker build -t webapp .
    docker run -p 8080:80 -d webapp
    curl http://127.0.0.1:8080

Create a whole application stack, using NetBox as an example:

* postgres
* redis
* redis-cache
* nginx
* netbox
* netbox-worker

    cd /vagrant/examples
    docker-compose -f netbox-compose.yml up

Cleanup after demo

    docker rm $(docker ps -aq)
