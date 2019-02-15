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

All Karaf data has been moved out of the installation directory and into
*/var/opt/fuse* (which is defined as a Docker volume). Additionally, the
*/opt/fuse/bin/setenv* script has been copied to
*/var/opt/fuse/bin/setenv* (and the former now sources the latter) so
that startup behavior may be configured.

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
volume* so that Karaf (and embedded AMQ broker) data and configuration
are persisted between runs:
```shell
$ docker volume create jboss-fuse-varopt
```

Run the Fuse instance, daemonized, with the OSGi HTTP port, Karaf SSH
port, and the embedded AMQ connector port mapped to the loopback
address:
```shell
$ docker run --name jboss-fuse --rm -dit -p 127.0.0.1:8181:8181 -p 127.0.0.1:8101:8101 -p 127.0.0.1:61616:61616 -v jboss-fuse-varopt:/var/opt/fuse --mount type=tmpfs,destination=/tmp,tmpfs-mode=1777 jboss-fuse:6.3.0
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

