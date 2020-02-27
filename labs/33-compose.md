# Docker Compose

* Prune the docker system on manager
* Clean up the images

    docker rmi webapp dbapp

* Go to /vagrant/app

## Explore the app source code

    less websvc/app.py
    less websvc/Dockerfile
    less web-compose.yml

## Building and running the web app

    docker-compose -f web-compose.yml build
    docker-compose -f web-compose.yml up

In another window execute

    docker ps
    docker network ls
    curl http://127.0.0.1:3000/
    curl http://127.0.0.1:3000/db/

### Logging

* Inspect the error logs
* Stop the app
* Restart the app as a daemon

    docker-compose -f stack-compose.yml up -d

* Repeat the CURL requests

### Cleanup

    docker-compose -f web-compose.yml down

## Building and running the app stack

    docker-compose -f stack-compose.yml build
    docker-compose -f stack-compose.yml up

* Cleanup

    docker-compose -f web-compose.yml down --volumes

## Run Netbox

    cd ~/netbox-docker/
    docker-compose up -d
    docker-compose port nginx 8080

* Connect to http://192.168.33.2:<port>/
