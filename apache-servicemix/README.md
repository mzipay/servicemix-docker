# Apache ServiceMix

**DISCLAIMER:** *THIS IMAGE IS INTENDED FOR LOCAL
DEVELOPMENT/EDUCATIONAL USE __ONLY__ AND IS __NOT SUITABLE__ FOR
DEPLOYMENT OF ANY KIND WITHOUT SUBSTANTIAL MODIFICATION.*

**ATTENTION:** *ALL EXPOSED PORTS SHOULD BE MAPPED EXPLICITLY TO THE
HOST LOOPBACK ADDRESS. DEVIATE FROM THIS AT YOUR OWN PERIL!*

------------------------------------------------------------------------

This image is based on [centos:7](https://hub.docker.com/_/centos) and
runs ServiceMix in a **headless** OpenJDK 8 JRE.

At the file system level, the ServiceMix installation is essentially
just an [Apache Karaf](https://karaf.apache.org/) installation, but with
a number of additional components "preloaded" (including [Apache Camel](
http://camel.apache.org/) and an embdded [ActiveMQ](
http://activemq.apache.org/) broker).

The ServiceMix installation is located at */opt/servicemix*. Maven is
installed at */opt/maven*. Both installations are owned by
``servicemix:servicemix``, and Karaf is prohibited from running as
``root``.

All Karaf data has been moved out of the installation directory and into
*/var/opt/servicemix* (which is defined as a Docker volume). The local
Maven repository resides at */var/opt/servicemix/local*.

The default username and password is smx/smx.

## Build the Apache ServiceMix Docker image

```shell
$ cd /your/development/area
$ git clone https://github.com/mzipay/servicemix-docker.git
```

1. Download the Apache Maven 3.6.0 **.tar.gz** binary distribution from
   https://maven.apache.org/download.cgi into the
   *servicemix-docker/apache-servicemix/* directory and verify the
   archive using SHA512 or GPG.
2. Download the Apache ServiceMix 7.0.1 **.zip** binary distribution
   from http://servicemix.apache.org/downloads.html into the
   *servicemix-docker/apache-servicemix/* directory and verify the
   archive using SHA1 or GPG.
3. Run the Docker build command:

```shell
$ cd servicemix-docker/apache-servicemix
$ docker build --tag apache-servicemix:7.0.1 .
```

## Run the Apache ServiceMix Docker image

Before running the image for the first time, create a Docker *named
volume* so that Karaf (and embedded ActiveMQ broker)  data and
configuration are persisted between runs:
```shell
$ docker volume create apache-servicemix-varopt
```

Run the ServiceMix instance, daemonized, with the OSGi HTTP port, Karaf
SSH port, and the embedded ActiveMQ connector port mapped to the
loopback address:
```shell
$ docker run --name apache-servicemix --rm -dit -p 127.0.0.1:8181:8181 -p 127.0.0.1:8101:8101 -p 127.0.0.1:61616:61616 -v apache-servicemix-varopt:/var/opt/servicemix --mount type=tmpfs,destination=/tmp,tmpfs-mode=1777 apache-servicemix:7.0.1
```

Start a Bash shell as the ``servicemix`` user in a running container:
```shell
$ docker exec -it apache-servicemix bash
```

SSH into the Karaf shell from the host:
```shell
$ ssh smx@127.0.0.1 -p 8101 -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null"
```
*(Note: The "-o" options are needed because the host name changes every
time a new container is started.)*

Stop the ServiceMix container:
```shell
$ docker attach apache-servicemix
halt
```
*(i.e. bring the container's Karaf shell to the foreground and issue the
halt command)*

