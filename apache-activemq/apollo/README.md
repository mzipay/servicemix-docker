# Apache ActiveMQ Apollo

**DISCLAIMER:** *THIS IMAGE IS INTENDED FOR LOCAL
DEVELOPMENT/EDUCATIONAL USE __ONLY__ AND IS __NOT SUITABLE__ FOR
DEPLOYMENT OF ANY KIND WITHOUT SUBSTANTIAL MODIFICATION.*

**ATTENTION:** *ALL EXPOSED PORTS SHOULD BE MAPPED EXPLICITLY TO THE
HOST LOOPBACK ADDRESS. DEVIATE FROM THIS AT YOUR OWN PERIL!*

------------------------------------------------------------------------

This image is based on [openjdk:8-jre-alpine](
https://hub.docker.com/_/openjdk) from [docker-library/openjdk](
https://github.com/docker-library/openjdk).

The Apollo instance is located at */var/opt/apache-apollo/broker* and is
owned by ``apollo:apollo``. The default account username/password is
"admin" / "password".

The ``apollo`` account's *.ashrc* exports BROKER\_HOME and JAVA\_HOME,
and a PATH with the broker and JRE executables prepended.

## Build the Apache ActiveMQ Apollo Docker image

```shell
$ cd /your/development/area
$ git clone https://github.com/mzipay/servicemix-docker.git
```

Download the Apache ActiveMQ Apollo 1.7.1 **.tar.gz** binary
distribution from https://activemq.apache.org/apollo/download.html into
the *servicemix-docker/apache-activemq/apollo/* directory, verify the
archive using GPG, then run the Docker build:

```shell
... GPG verification omitted ...
$ mv apache-apollo-1.7.1-unix-distro.tar.gz servicemix-docker/apache-activemq/apollo/
$ cd servicemix-docker/apache-activemq/apollo
$ docker build --tag apache-activemq-apollo:1.7.1 .
```

## Run the Apache ActiveMQ Apollo Docker image

Before running the image for the first time, create a Docker *named
volume* so that broker data and configuration are persisted between
runs:
```shell
$ docker volume create apache-apollo-broker
```

Run the Apollo instance, daemonized, with the admin web console ports
as well as the OpenWire/AMQP/MQTT/STOMP and WebSockets connector ports
mapped to the loopback address:
```shell
$ docker run --name activemq-apollo --rm -dit -p 127.0.0.1:61680:61680 -p 127.0.0.1:61681:61681 -p 127.0.0.1:61613:61613 -p 127.0.0.1:61614:61614 -p 127.0.0.1:61623:61623 -p 127.0.0.1:61624:61624 -v apache-apollo-broker:/var/opt/apache-apollo/broker apache-activemq-apollo:1.7.1
```

Start an Ash shell as the ``apollo`` user in a running container:
```shell
$ docker exec -it activemq-apollo ash
```

Stop the Apollo container:
```shell
$ docker attach activemq-apollo
^C
```
*(i.e. bring the container to the foreground and then Ctrl-C the process)*

