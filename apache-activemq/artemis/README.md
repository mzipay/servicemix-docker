# Apache ActiveMQ Artemis

**DISCLAIMER:** *THIS IMAGE IS INTENDED FOR LOCAL
DEVELOPMENT/EDUCATIONAL USE __ONLY__ AND IS __NOT SUITABLE__ FOR
DEPLOYMENT OF ANY KIND WITHOUT SUBSTANTIAL MODIFICATION.*

**ATTENTION:** *ALL EXPOSED PORTS SHOULD BE MAPPED EXPLICITLY TO THE
HOST LOOPBACK ADDRESS. DEVIATE FROM THIS AT YOUR OWN PERIL!*

------------------------------------------------------------------------

This image is based on [openjdk:11-jre-slim-stretch](
https://hub.docker.com/_/openjdk) from [docker-library/openjdk](
https://github.com/docker-library/openjdk).

The Artemis instance is located at */var/opt/apache-artemis/broker*,
is owned by ``artemis:artemis``, and is configured by default to require
login (admin/passw0rd).

The ``artemis`` account's *.bashrc* exports BROKER\_HOME and JAVA\_HOME,
and a PATH with the broker and JRE executables prepended.

## Build the Apache ActiveMQ Artemis Docker image

```shell
$ cd /your/development/area
$ git clone https://github.com/mzipay/servicemix-docker.git
```

Download the Apache ActiveMQ Artemis 2.6.3 **.tar.gz** binary
distribution from https://activemq.apache.org/artemis/download.html into
the *servicemix-docker/apache-activemq/artemis/* directory, verify the
archive using SHA512 or GPG, then run the Docker build:
```shell
... SHA512/GPG verification omitted ...
$ mv apache-artemis-2.6.3-bin.tar.gz servicemix-docker/apache-activemq/artemis/
$ cd servicemix-docker/apache-activemq/artemis
$ docker build --tag apache-activemq-artemis:2.6.3 .
```

## Run the Apache ActiveMQ Artemis Docker image

Before running the image for the first time, create a Docker *named
volume* so that broker data and configuration are persisted between
runs:
```shell
$ docker volume create apache-artemis-broker
```

Run the Artemis instance, daemonized, with the Hawtio console port and
all default acceptor ports (OpenWire, AMQP, MQTT, STOMP) mapped to the
loopback address:
```shell
$ docker run --name activemq-artemis --rm -dit -p 127.0.0.1:8161:8161 -p 127.0.0.1:61616:61616 -p 127.0.0.1:5672:5672 -p 127.0.0.1:1883:1883 -p 127.0.0.1:61613:61613 -v apache-artemis-broker:/var/opt/apache-artemis/broker apache-activemq-artemis:2.6.3
```

Start a Bash shell as the ``artemis`` user in a running container:
```shell
$ docker exec -it activemq-artemis bash
```

Stop the Artemis container:
```shell
$ docker exec activemq-artemis bin/artemis stop
```

Less elegant, alternative ways to end the Artemis container process:
```shell
$ docker exec activemq-artemis bin/artemis kill
```
```shell
$ docker attach activemq-artemis
^C
```
*(i.e. bring the container to the foreground and then Ctrl-C the process)*

