# Apache Archiva

**DISCLAIMER:** *THIS IMAGE IS INTENDED FOR LOCAL
DEVELOPMENT/EDUCATIONAL USE __ONLY__ AND IS __NOT SUITABLE__ FOR
DEPLOYMENT OF ANY KIND WITHOUT SUBSTANTIAL MODIFICATION.*

**ATTENTION:** *ALL EXPOSED PORTS SHOULD BE MAPPED EXPLICITLY TO THE
HOST LOOPBACK ADDRESS. DEVIATE FROM THIS AT YOUR OWN PERIL!*

------------------------------------------------------------------------

This image is based on [openjdk:8-jre-alpine](
https://hub.docker.com/_/openjdk) from [docker-library/openjdk](
https://github.com/docker-library/openjdk).

The Archiva installation is located at */opt/archiva*, is owned by
``archiva:archiva``, and will refuse to run as ``root``.

All Archiva configuration and data has been moved out of the
installation directory and into */var/opt/archiva* (which is defined as
a Docker volume). The Archiva web application is served from
*/srv/apps/archiva*, which is also owned by ``archiva:archiva``. (At
runtime, the web application is served from the context */archiva*.)

There is no default account for Archiva. You must create an admin
account on first run, then use that admin account to create user
accounts.

## Build the Apache Archiva Docker image

```shell
$ cd /your/development/area
$ git clone https://github.com/mzipay/servicemix-docker.git
```

Download an Apache Archiva **.tar.gz** binary distribution from
https://archiva.apache.org/download.cgi into the
*servicemix-docker/apache-archiva/* directory and verify the archive
using MD5/SHA or GPG, then run the Docker build:

```shell
... MD5/SHA/GPG verification omitted ...
$ mv apache-archiva-2.2.3-bin.tar.gz servicemix-docker/apache-archiva/
$ cd servicemix-docker/apache-archiva
$ docker build --tag apache-archiva:2.2.3 .
```

## Run the Apache Archiva Docker image

Before running the image for the first time, create a Docker *named
volume* so that Archiva data and configuration are persisted between
runs:
```shell
$ docker volume create apache-archiva-varopt
```

Run the Archiva instance, daemonized, with the web application port
mapped to the loopback address:
```shell
$ docker run --name apache-archiva --rm -dit -p 127.0.0.1:8080:8080 -v apache-archiva-varopt:/var/opt/archiva --mount type=tmpfs,destination=/tmp,tmpfs-mode=1777 apache-archiva:2.2.3
```
*(the Archiva web application is now available at
http://localhost:8080/archiva)*

Start an Ash shell as the ``archiva`` user in a running container:
```shell
$ docker exec -it apache-archiva ash
```

Stop the Archiva container:
```shell
$ docker attach apache-archiva
^C
```
*(i.e. bring the container to the foreground and then Ctrl-C the process)*

