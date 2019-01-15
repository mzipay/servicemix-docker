# Apache Karaf

**DISCLAIMER:** *THIS IMAGE IS INTENDED FOR LOCAL
DEVELOPMENT/EDUCATIONAL USE __ONLY__ AND IS __NOT SUITABLE__ FOR
DEPLOYMENT OF ANY KIND WITHOUT SUBSTANTIAL MODIFICATION.*

**ATTENTION:** *ALL EXPOSED PORTS SHOULD BE MAPPED EXPLICITLY TO THE
HOST LOOPBACK ADDRESS. DEVIATE FROM THIS AT YOUR OWN PERIL!*

------------------------------------------------------------------------

This image is based on [openjdk:8-jre-alpine](
https://hub.docker.com/_/openjdk) from [docker-library/openjdk](
https://github.com/docker-library/openjdk).

The Karaf installation is located at */opt/karaf*. Maven is installed at
*/opt/maven*. Both installations are owned by ``karaf:karaf``, and Karaf
is prohibited from running as ``root``.

All Karaf data has been moved out of the installation directory and into
*/var/opt/karaf* (which is defined as a Docker volume). The local Maven
repository resides at */var/opt/karaf/local*.

The default username and password is karaf/karaf.

## Build the Apache Karaf Docker image

```shell
$ cd /your/development/area
$ git clone https://github.com/mzipay/servicemix-docker.git
```

1. Download the Apache Maven 3.6.0 **.tar.gz** binary distribution from
   https://maven.apache.org/download.cgi into the
   *servicemix-docker/apache-karaf/* directory and verify the
   archive using SHA512 or GPG.
2. Download the Apache Karaf 4.2.2 **.tar.gz** binary distribution
   from https://karaf.apache.org/download.html into the
   *servicemix-docker/apache-karaf/* directory and verify the
   archive using SHA1 or GPG.
3. Run the Docker build command:

```shell
... SHA512/GPG verification omitted ...
$ mv apache-maven-3.6.0-bin.tar.gz servicemix-docker/apache-karaf/
$ mv apache-karaf-4.2.2.tar.gz servicemix-docker/apache-karaf/
$ cd servicemix-docker/apache-karaf
$ docker build --tag apache-karaf:4.2.2 .
```

## Run the Apache Karaf Docker image

Before running the image for the first time, create a Docker *named
volume* so that Karaf data and configuration are persisted between runs:
```shell
$ docker volume create apache-karaf-varopt
```

Run the Karaf instance, daemonized, with the Hawtio console port, Karaf
SSH port and JMX/RMI ports mapped to the loopback address:
```shell
$ docker run --name apache-karaf --rm -dit -p 127.0.0.1:8181:8181 -p 127.0.0.1:8101:8101 -p 127.0.0.1:51099:1099 -p 127.0.0.1:54444:44444 -v apache-karaf-varopt:/var/opt/karaf --mount type=tmpfs,destination=/tmp,tmpfs-mode=1777 apache-karaf:4.2.2
```

Start an Ash shell as the ``karaf`` user in a running container:
```shell
$ docker exec -it apache-karaf ash
```

SSH into the Karaf shell from the host:
```shell
$ ssh karaf@127.0.0.1 -p 8101 -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null"
```
*(Note: The "-o" options are needed because the host name changes every
time a new container is started.)*

Stop the Karaf container:
```shell
$ docker attach apache-karaf
halt
```
*(i.e. bring the container's Karaf shell to the foreground and issue the
halt command)*

