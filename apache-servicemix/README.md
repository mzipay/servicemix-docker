# Apache ServiceMix

**DISCLAIMER:** *THIS IMAGE IS INTENDED FOR LOCAL
DEVELOPMENT/EDUCATIONAL USE __ONLY__ AND IS __NOT SUITABLE__ FOR
DEPLOYMENT OF ANY KIND WITHOUT SUBSTANTIAL MODIFICATION.*

**ATTENTION:** *ALL EXPOSED PORTS SHOULD BE MAPPED EXPLICITLY TO THE
HOST LOOPBACK ADDRESS. DEVIATE FROM THIS AT YOUR OWN PERIL!*

------------------------------------------------------------------------

This image is based on *centos:7* and runs ServiceMix in a **headless**
OpenJDK 8 JRE.

At the file system level, the ServiceMix installation is essentially
just an Apache Karaf installation, but with a number of additional
components "preloaded" (including an embdded ActiveMQ 5.14.5 broker).

This image re-defines the ``KARAF_DATA`` and ``KARAF_ETC`` locations
so that they reside under */var/opt/apache-servicemix/instance* (and
can therefore be persisted with a Docker volume). Additionally, the
image defines */opt/apache-servicemix-7.0.1/deploy* as a volume.

Both */var/opt/apache-servicemix/instance* and
*/opt/apache-servicemix-7.0.1* are owned by ``servicemix:servicemix``,
and the Karaf instance is explicitly prohibited to run as root.

The default username and password for the Karaf shell is smx/smx.

The ``servicemix`` account's *.bashrc* exports JAVA\_HOME and
MAVEN\_HOME, and a PATH with the Maven and JRE executables
prepended.

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
$ docker volume create apache-servicemix-instance
```

Additionally, create a Docker *named volume* for the ServiceMix
*deploy/* directory so that OSGi bundles may be hot-deployed directly
from the host:
```shell
$ docker volume create apache-servicemix-deploy
```

Run the ServiceMix instance, daemonized, with the OSGi HTTP port, Karaf
SSH port, and the embedded ActiveMQ connector port mapped to the
loopback address:
```shell
$ docker run --name apache-servicemix --rm -dit -p 127.0.0.1:8181:8181 -p 127.0.0.1:8101:8101 -p 127.0.0.1:61616:61616 -v apache-servicemix-instance:/var/opt/apache-servicemix/instance -v apache-servicemix-deploy:/opt/apache-servicemix-7.0.1/deploy apache-servicemix:7.0.1
```

Start a Bash shell as the ``servicemix`` user in a running container:
```shell
$ docker exec -it apache-servicemix bash
```

Stop the ServiceMix container:
```shell
$ docker attach apache-servicemix
halt
```
*(i.e. bring the container's Karaf shell to the foreground and issue the
halt command)*

