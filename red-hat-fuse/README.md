# Red Hat Fuse

**DISCLAIMER:** *THIS IMAGE IS INTENDED FOR LOCAL
DEVELOPMENT/EDUCATIONAL USE __ONLY__ AND IS __NOT SUITABLE__ FOR
DEPLOYMENT OF ANY KIND WITHOUT SUBSTANTIAL MODIFICATION.*

**ATTENTION:** *ALL EXPOSED PORTS SHOULD BE MAPPED EXPLICITLY TO THE
HOST LOOPBACK ADDRESS. DEVIATE FROM THIS AT YOUR OWN PERIL!*

------------------------------------------------------------------------

This image is based on [centos:7](https://hub.docker.com/_/centos) and
runs Fuse in a **headless** OpenJDK 8 JRE.

*(Note: There is an existing Fuse *Dockerfile* available from
[jboss-fuse/jboss-fuse-docker](
https://github.com/jboss-fuse/jboss-fuse-docker), but it has not been
updated in years and depends on the long-defunct JDK 7.)*

At the file system level, the Fuse installation is essentially just an
[Apache Karaf](https://karaf.apache.org/) installation, but with a
number of additional components "preloaded" (including [Apache Camel](
http://camel.apache.org/), embdded [Red Hat AMQ](
https://www.redhat.com/en/technologies/jboss-middleware/amq) broker,
[Narayana](http://narayana.io/) transaction manager and [Undertow](
http://undertow.io/) Web server).

The Fuse installation is located at */opt/fuse*. Maven is installed at
*/opt/maven*. Both installations are owned by ``fuse:fuse``, and Karaf
is prohibited from running as ``root``.

All Karaf data has been moved out of the installation directory and into
*/var/opt/fuse* (which is defined as a Docker volume). The local Maven
repository resides at */var/opt/fuse/local*.

The default username and password is admin/admin. *(Note: this account
left disabled by the default Fuse install, but __enabled__ in this
image.)*

## Build the Red Hat Fuse Docker image

```shell
$ cd /your/development/area
$ git clone https://github.com/mzipay/servicemix-docker.git
```

1. Download the Apache Maven 3.6.0 **.tar.gz** binary distribution from
   https://maven.apache.org/download.cgi into the
   *servicemix-docker/red-hat-fuse/* directory and verify the
   archive using SHA512 or GPG.
2. Download the Red Hat Fuse 7.2.0 **.zip** binary distribution
   from https://developers.redhat.com/products/fuse/download/ (requires
   Red Hat Developer registration) into the
   *servicemix-docker/red-hat-fuse/* directory.
3. Run the Docker build command:

```shell
$ cd servicemix-docker/red-hat-fuse
$ docker build --tag red-hat-fuse:7.2.0 .
```

## Run the Red Hat Fuse Docker image

Before running the image for the first time, create a Docker *named
volume* so that Karaf (and embedded AMQ broker) data and configuration
are persisted between runs:
```shell
$ docker volume create red-hat-fuse-varopt
```

Run the Fuse instance, daemonized, with the OSGi HTTP port, Karaf SSH
port, and the embedded AMQ connector port mapped to the loopback
address:
```shell
$ docker run --name red-hat-fuse --rm -dit -p 127.0.0.1:8181:8181 -p 127.0.0.1:8101:8101 -p 127.0.0.1:61616:61616 -v red-hat-fuse-varopt:/var/opt/fuse --mount type=tmpfs,destination=/tmp,tmpfs-mode=1777 red-hat-fuse:7.2.0
```

Start a Bash shell as the ``fuse`` user in a running container:
```shell
$ docker exec -it red-hat-fuse bash
```

SSH into the Karaf shell from the host:
```shell
$ ssh admin@127.0.0.1 -p 8101 -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null"
```
*(Note: The "-o" options are needed because the host name changes every
time a new container is started.)*

Stop the Fuse container:
```shell
$ docker attach red-hat-fuse
halt
```
*(i.e. bring the container's Karaf shell to the foreground and issue the
halt command)*

