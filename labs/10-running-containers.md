# Starting Docker Containers

Commands used in this demo:

* **docker run <image>** - start a Docker container
* **docker run -it** - start an interactive container (-i) and create a TTY device for it (-t)
* **docker ps** - display running Docker containers
* **docker ps -a** - display all Docker containers
* **docker start** - restart a stopped container
* **docker build -t <image>** - build a local Docker image

## Launch a Container Image

**docker run** downloads a container image (if needed), starts the container, and executes the specified command.

    docker run -it busybox
    docker run -it alpine
    apk add tree

Exit alpine container, rerun it...

    docker run -it alpine

Find previous container, restart it...

    docker ps -a
    docker start -i <name>

Run a tool that is not installed on your system

    perl -v
    docker run perl:latest perl -v
    cd /vagrant/examples
    cat hello-world.pl
    docker run -v $(pwd):/work -w /work perl:latest perl hello-world.pl
    alias perl='docker run -v $(pwd):/work -w /work perl:latest perl'
    perl -v

Build a network automation environment (not part of the recorded demo):

		cd /vagrant/app/ansible
		docker build -t ansible .

Execute Ansible playbook in a Docker container:

    cat /vagrant/app/ansible/Dockerfile
    docker run ansible ansible-playbook --version

    cd /vagrant/examples
    docker run -v $(pwd):/work ansible ansible-playbook -v playbook.yml

