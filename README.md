# Packet tracer in a container

### Description
-------
docker-pt is a container for cisco's packet tracer program. Packet tracer is automatically installed in a container and can be conveniently used from there.
Prerequisite is an XServer, which is provided to the container as a volume. Furthermore a current installation of docker.

### Build
**1. Get the repository**
#### https
```https
curl https://raw.githubusercontent.com/devd4n/docker_packet-tracer/main/install.sh
```
**2. Get Helper for X11 support**
```https
curl https://raw.githubusercontent.com/devd4n/docker_starter/main/install.sh | bash
```

**2. Navigate to the repo**
```bash
make build   # creates a docker image (packettracer)
make runX11     # starts packettracer and creates a GUI Session
make clean   # removes packettracer image
```
