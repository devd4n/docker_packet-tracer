# Packet tracer in a container

### Description
-------
docker-pt is a container for cisco's packet tracer program. Packet tracer is automatically installed in a container and can be conveniently used from there.
Prerequisite is an XServer, which is provided to the container as a volume. Furthermore a current installation of docker.

### Build
**1. Get the repository**
#### https
```https
git clone https://github.com/devd4n/docker_packet-tracer.git
```

**2. Navigate to the repo**
```bash
make build   # creates a docker image (packettracer)
make run     # starts packettracer
make shell   # opens a shell in the container
make clean   # removes packettracer image

```

### Troubleshooting
If you receive an error like
```
QXcbConnection: Could not connect to display
```
your docker daemon isn't authorized to use your local XServer session. Fix:
```
xhost +local:docker
```

### TODO
-------
- Build a flatpak





### Problem with uid 1000
https://stackoverflow.com/questions/26145351/why-doesnt-chown-work-in-dockerfile

Problem:
With a simple Dockerfile as follows:

FROM ubuntu:16.04
RUN useradd -m -d /home/new_user new_user
COPY test_file.txt /home/new_user
RUN chown -R new_user:new_user /home/new_user
CMD ls -RFlag /home
After running:

echo "A file to test permissions." > test_file.txt
docker build -t chown-test -f Dockerfile .
docker run --rm -it chown-test
The output was:

/home:
total 12
drwxr-xr-x 1 root 4096 Jun 15 21:37 ./
drwxr-xr-x 1 root 4096 Jun 15 21:39 ../
drwxr-xr-x 1 root 4096 Jun 15 21:39 new_user/

/home/new_user:
total 24
drwxr-xr-x 1 root 4096 Jun 15 21:39 ./
drwxr-xr-x 1 root 4096 Jun 15 21:37 ../
-rw-r--r-- 1 root  220 Aug 31  2015 .bash_logout
-rw-r--r-- 1 root 3771 Aug 31  2015 .bashrc
-rw-r--r-- 1 root  655 Jul 12  2019 .profile
-rw-r--r-- 1 root   28 Jun 11 19:48 test_file.txt
As you can see the file ownership (e.g. test_file.txt) is still associated with user root.

Solution:
I found that if I used a numeric UID in the chown command, I could change the ownership, but only if the UID was not 1000. So I added 1 to the UID of new_user and then changed the ownership.
