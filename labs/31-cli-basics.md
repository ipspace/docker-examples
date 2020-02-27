# Basic Docker CLI commands

## Launch a container

**docker run** downloads a container image (if needed), starts the container,
and executes the specified command.

    docker run busybox echo Hello World

Display running containers with `docker ps` and all containers with `docker ps -a`

## Launch an interactive container

**docker run -i** - keep STDIN open

**docker run -t** - allocate a TTY

    docker run -i busybox
    docker run -it busybox

Inspect the list of docker containers

    docker ps -a

Run a container with a cleanup option

    docker run --rm busybox echo Hello World

## Launch a long-running container

Execute an infinite loop:

    docker run busybox /bin/sh -c "while true; do date; sleep 1; done"

Run the infinite loop in a detached container:

    docker run -d busybox /bin/sh -c "while true; do date; sleep 1; done"

Attach to the container, and kill it with ctrl-c

    docker ps
    docker attach <id>

Restart the container with **docker start**

    docker ps -a
    docker start <id>

Examine the container logs with **docker logs**

    docker ps
    docker logs <id>

## Name a container

Use **--name** option of **docker run** to name your container. You can use that name in
instead of container ID in further **docker** commands.

    docker run -d --name busy busybox /bin/sh -c "while true; do date; sleep 1; done"
    docker ps
    docker logs busy
    docker kill busy

## Execute additional commands in a container

Start a long-running container (you might need to run **docker rm busy** first):

    docker run -d --name busy busybox /bin/sh -c "while true; do date; sleep 1; done"

Execute another command in that same container:

    docker exec busy ps -ef

Start an interactive shell in that container:

    docker exec -it busy sh

## Cleanup after demo

* List all Docker containers
* Display a short list of container IDs
* Remove all containers

    docker ps -a
    docker ps -aq
    docker rm $(docker ps -aq)
