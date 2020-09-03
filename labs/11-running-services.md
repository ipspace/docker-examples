# Starting Docker Services

Commands used in this demo:

* **docker build -t <image>** - build a local Docker image
* **docker run -d** - start a daemon (background process) container
* **docker ps** - display running Docker containers
* **docker kill <name>** - stop (but not remove) a Docker container
* **docker compose** - deploy or stop an application stack described in `docker-compose.yml`
* **docker system prune** - remove stale Docker objects (stopped containers, unused networks...)

## Build and Deploy a Web Service

Build a local image containing a Python Flask application:

    cd /vagrant/app/websvc
    cat Dockerfile
    docker build -t webapp .
    
Run the Flask-based web server in a container, mapping container port 80 to host port 8080:

    docker run -p 8080:80 -d webapp
    curl http://127.0.0.1:8080

Stop the web server

    docker ps
    docker kill <name>

## Deploying an application stack

Create a whole application stack, using NetBox as an example:

* postgres
* redis
* redis-cache
* nginx
* netbox
* netbox-worker

Clone the Netbox Docker repository:

		cd ~
		git clone https://github.com/netbox-community/netbox-docker
		
Add published port mapping to nginx part of `docker-compose.yml` file:

    nginx:
    ...
      ports:
      - 8080:8080

Create the application stack

    cd ~/netbox-docker/
    docker-compose up

Cleanup after demo

    docker-compose down
    
## Cleanup

Remove all stale containers:

    docker system prune
