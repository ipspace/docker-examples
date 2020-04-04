## Namespace and Overlay Volumes demos

### Process Namespaces

    docker run -it busybox
    ps -elf
    top

Execute `ps -elf` within another terminal window

### UID Namespace

Start a new container with

    docker run -it -v /:/host busybox`

Execute `whoami`

Explore /etc/passwd, /host/etc/passwd, /host/etc/shadow. Display host mount

    mount|grep host
    mount|grep "host "

Start container with the root process running as current UID

    docker run -u $UID -it -v /:/host busybox`

Start a new container and try to shut down Ethernet interface

    docker run -it alpine
    ifconfig eth0 down

### Mount Point Namespaces

Execute **ls -lR** within a busybox container. Display file system mounts.

Touch a file in the container, find the file in host file system with

    sudo find / -name Waldo -print

Display the `diff` and `merged` version of the volume

### Overlay File System

Run a busybox image, create a file

    docker run -it busybox
    touch foobar

Find the file in another window

    sudo find / -name foobar -print

Exit the container, show that the merged layer no longer exists. Start another container, show that it does not have the **foobar** file, create it, and find both files in the overlay file system.

* Remove **/bin/tee** in a busybox image
* Show the whiteout file in top layer

Also

* Inspect layers with `docker container inspect name` and `docker history`

Persistent storage: volumes

    docker volume create scratch
    docker run -it -v scratch:/work busybox
    touch work/Waldo
    <exit>
    docker run -it -v scratch:/work busybox
    ls work

In another window start an Alpine container mapping the same volume

    docker run -it -v scratch:/work alpine
    ls work

Find where the volume is:

    sudo find / -name Waldo -print

### Build a New Image

    cd /vagrant/websvc
    docker build -t webapp .

* Explore the image with `docker history webapp`

### Network namespace

Run an Alpine image, execute a few network commands

    docker run -it alpine
    ifconfig
    ip route
    nslookup www.example.com
    traceroute -w 1 www.example.com

Look from the outside

    ip address
    brctl show
    ip route
