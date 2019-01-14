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

This image re-defines the ``KARAF_DATA`` and ``KARAF_ETC`` locations
so that they reside under */var/opt/red-hat-fuse/instance* (and can
therefore be persisted with a Docker volume). Additionally, the image
defines */opt/fuse-karaf-7.2.0.fuse-720035-redhat-00001/deploy* as a
volume.

Both */var/opt/red-hat-fuse/instance* and
*/opt/fuse-karaf-7.2.0.fuse-720035-redhat-00001* are owned by
``fuse:fuse``, and the Karaf instance is explicitly prohibited to run
as root.

The default username and password is admin/admin. *(Note: this account
left disabled by the default Fuse install, but __enabled__ in this
image.)*

The ``fuse`` account's *.bashrc* exports JAVA\_HOME and MAVEN\_HOME, and
a PATH with the Maven and JRE executables prepended.

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
$ docker volume create red-hat-fuse-instance
```

Additionally, create a Docker *named volume* for the Fuse *deploy/*
directory so that OSGi bundles may be hot-deployed directly from the
host:
```shell
$ docker volume create red-hat-fuse-deploy
```

Run the Fuse instance, daemonized, with the OSGi HTTP port, Karaf SSH
port, and the embedded AMQ connector port mapped to the loopback
address:
```shell
$ docker run --name red-hat-fuse --rm -dit -p 127.0.0.1:8181:8181 -p 127.0.0.1:8101:8101 -p 127.0.0.1:61616:61616 -v red-hat-fuse-instance:/var/opt/red-hat-fuse/instance -v red-hat-fuse-deploy:/opt/fuse-karaf-7.2.0.fuse-720035-redhat-00001/deploy red-hat-fuse:7.2.0
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

