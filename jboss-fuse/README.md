# JBoss Fuse

**DISCLAIMER:** *THIS IMAGE IS INTENDED FOR LOCAL
DEVELOPMENT/EDUCATIONAL USE __ONLY__ AND IS __NOT SUITABLE__ FOR
DEPLOYMENT OF ANY KIND WITHOUT SUBSTANTIAL MODIFICATION.*

**ATTENTION:** *ALL EXPOSED PORTS SHOULD BE MAPPED EXPLICITLY TO THE
HOST LOOPBACK ADDRESS. DEVIATE FROM THIS AT YOUR OWN PERIL!*

------------------------------------------------------------------------

This image is based on [centos:7](https://hub.docker.com/_/centos) and
runs Fuse in a **headless** OpenJDK 8 JRE.

The Fuse installation is located at */opt/fuse* and is owned by
``fuse:fuse``. Karaf is prohibited from running as ``root``.

The default username and password is admin/admin. *(Note: this account
left disabled by the default Fuse install, but __enabled__ in this
image.)*

## Build the JBoss Fuse Docker image

```shell
$ cd /your/development/area
$ git clone https://github.com/mzipay/servicemix-docker.git
```

1. Download the JBoss Fuse 6.3.0 **.zip** binary distribution
   from https://developers.redhat.com/products/fuse/download/ (requires
   Red Hat Developer registration) into the
   *servicemix-docker/jboss-fuse/* directory.
3. Run the Docker build command:

```shell
$ cd servicemix-docker/jboss-fuse
$ docker build --tag jboss-fuse:6.3.0 .
```

## Run the JBoss Fuse Docker image

Before running the image for the first time, create a Docker *named
volume* for the bin/, data/, deploy/ and etc/ Fuse subdirectories so that
data and configuration are persisted between runs:
```shell
$ docker volume create jboss-fuse-bin
$ docker volume create jboss-fuse-data
$ docker volume create jboss-fuse-deploy
$ docker volume create jboss-fuse-etc
```

Run the Fuse instance, daemonized, with the OSGi HTTP port, Karaf SSH
port, and the embedded AMQ connector port mapped to the loopback
address:
```shell
$ docker run --name jboss-fuse --rm -dit -p 127.0.0.1:8181:8181 -p 127.0.0.1:8101:8101 -p 127.0.0.1:61616:61616 -v jboss-fuse-bin:/opt/fuse/bin -v jboss-fuse-data:/opt/fuse/data -v jboss-fuse-deploy:/opt/fuse/deploy -v jboss-fuse-etc:/opt/fuse/etc --mount type=tmpfs,destination=/tmp,tmpfs-mode=1777 jboss-fuse:6.3.0
```

Start a Bash shell as the ``fuse`` user in a running container:
```shell
$ docker exec -it jboss-fuse bash
```

SSH into the Karaf shell from the host:
```shell
$ ssh admin@127.0.0.1 -p 8101 -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null"
```
*(Note: The "-o" options are needed because the host name changes every
time a new container is started.)*

Stop the Fuse container:
```shell
$ docker attach jboss-fuse
osgi:shutdown
```
*(i.e. bring the container's Karaf shell to the foreground and issue the
osgi:shutdown command)*

