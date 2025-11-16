[![2.11BSD](https://github.com/matushorvath/pdp11/actions/workflows/build-2.11bsd.yml/badge.svg)](https://github.com/matushorvath/pdp11/actions/workflows/build-2.11bsd.yml)
[![Unix v6](https://github.com/matushorvath/pdp11/actions/workflows/build-unix-v6.yml/badge.svg)](https://github.com/matushorvath/pdp11/actions/workflows/build-unix-v6.yml)
[![Docker Image Version](https://img.shields.io/docker/v/matushorvath/pdp11?logo=docker&label=pdp11)](https://hub.docker.com/repository/docker/matushorvath/pdp11)
[![Docker Image Version](https://img.shields.io/docker/v/matushorvath/pdp11-2.11bsd?logo=docker&label=pdp11-2.11bsd)](https://hub.docker.com/repository/docker/matushorvath/pdp11-2.11bsd)
[![Docker Image Version](https://img.shields.io/docker/v/matushorvath/pdp11-2.11bsd-httpd?logo=docker&label=pdp11-2.11bsd-httpd)](https://hub.docker.com/repository/docker/matushorvath/pdp11-2.11bsd-httpd)
[![Docker Image Version](https://img.shields.io/docker/v/matushorvath/unix-v6?logo=docker&label=unix-v6)](https://hub.docker.com/repository/docker/matushorvath/unix-v6)

UNIX on Emulated PDP11 in Docker
================================

2.11BSD
-------

A web server running on a recent version of 2BSD:
 - DEC [PDP-11/93](https://gunkies.org/wiki/PDP-11/93) with 4 MB of memory
   and 456 MB [RA81](https://gunkies.org/wiki/RA81_Disk_Drive) disk drive
 - emulated by [Open SimH 4.x](https://github.com/open-simh/simh.git)
 - running [2.11BSD](https://www.tuhs.org/Archive/Distributions/UCB/2.11BSD-patch481)
   installed from tape during container build and patched to a recent version
 - full internet connectivity using a DEC 
   [DELQA](https://gunkies.org/wiki/DIGITAL_Ethernet_Local-Area-Network_to_Q-bus_Adapter)
   ethernet adapter
 - serving HTTP using [2.11BSD httpd](https://github.com/AaronJackson/2.11BSDhttpd.git),
   exposed from docker on port 80

### Try it out

```sh
$ docker run -it -p 8080:80 matushorvath/pdp11-2.11bsd-httpd
```

Or build your own image:

```sh
$ cd 2.11bsd
$ docker build -t 2.11bsd .
$ docker run -it -p 8080:80 2.11bsd
```

After you see the `login:` prompt, navigate your web browser to
[http://localhost:8080](http://localhost:8080).
You should see an "It works!" web page served by the PDP-11.

To shut down the server, either stop the docker, or log in as `root` (no password) and run `shutdown -h now`.

UNIX v6
-------

[Ancient UNIX](https://www.tuhs.org/Archive/Distributions/Other/OS_Course/v6/)
in a container, installed from tape during container build.

Publishing
----------

1. Prepare the release in the `main` branch
1. Tag the commit with the version number:
   ```sh
   $ git tag v0.1.0 main
   ```
1. Push the tag to GitHub:
   ```sh
   $ git push origin tag v0.1.0
   ```
1. GitHub Actions will publish docker images to Docker Hub

GitHub Actions setup: https://docs.docker.com/guides/reactjs/configure-github-actions
