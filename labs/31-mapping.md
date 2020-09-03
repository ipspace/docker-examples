# Mapping Host Directories and Cleaning Up

Map a host directory into a container directory:

    docker run -it -v $(pwd):/work busybox
    docker run -it -v $(pwd):/work -w /work busybox
    docker run -it -v $(pwd):/work -w /work busybox ls

Mount the root file system just for the giggles:

    docker run -it -v /:/host busybox

## Cleanup after demo

We'll remove all containers using these steps:

* List all Docker containers
* Display a short list of container IDs
* Kill all running containers
* Remove all containers

Execute:

    docker ps -a
    docker ps -aq
    docker kill $(docker ps -q)
    docker rm $(docker ps -aq)

* List all images
* Remove an image

Execute:

    docker image ls
    docker rmi <name>
