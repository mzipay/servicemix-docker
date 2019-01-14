# Apache ActiveMQ

**DISCLAIMER:** *THIS IMAGE IS INTENDED FOR LOCAL
DEVELOPMENT/EDUCATIONAL USE __ONLY__ AND IS __NOT SUITABLE__ FOR
DEPLOYMENT OF ANY KIND WITHOUT SUBSTANTIAL MODIFICATION.*

**ATTENTION:** *ALL EXPOSED PORTS SHOULD BE MAPPED EXPLICITLY TO THE
HOST LOOPBACK ADDRESS. DEVIATE FROM THIS AT YOUR OWN PERIL!*

------------------------------------------------------------------------

This image is based on [centos:7](https://hub.docker.com/_/centos) and
runs ActiveMQ in a **headless** OpenJDK 8 JRE.

Unlike the [Artemis](https://activemq.apache.org/artemis/) and [Apollo](
https://activemq.apache.org/apollo/) subprojects, there is no file
system-level distinction between the **installation** and the broker
**instance** with classic ActiveMQ. However, the *bin/env* script does
contain options that can effectively duplicate such a separation. This
image takes advantage of those options to define an ``ACTIVEMQ_INST``
environment variable pointing to */var/opt/apache-activemq/instance*,
and to re-define the ``ACTIVEMQ_CONF``, ``ACTIVEMQ_DATA`` and
``ACTIVEMQ_TMP`` environment variables in terms of ``ACTIVEMQ_INST``.

Both the ActiveMQ installation (*/opt/apache-activemq-5.15.8*) and the
instance data (*/var/opt/apache-activemq/instance*) are owned by
``activemq:activemq``. The default username and password for the web
administration console is admin/admin.

The ``activemq`` account's *.bashrc* exports JAVA\_HOME and
ACTIVEMQ\_HOME, and a PATH with the ActiveMQ and JRE executables
prepended.

## Build the Apache ActiveMQ Docker image

```shell
$ cd /your/development/area
$ git clone https://github.com/mzipay/servicemix-docker.git
```

Download the Apache ActiveMQ 5.15.8 **.tar.gz** binary distribution from
https://activemq.apache.org/activemq-5158-release.html into the
*servicemix-docker/apache-activemq/classic/* directory, verify the
archive using SHA512 or GPG, then run the Docker build:
```shell
... SHA512/GPG verification omitted ...
$ mv apache-activemq-5.15.8-bin.tar.gz servicemix-docker/apache-activemq/classic/
$ cd servicemix-docker/apache-activemq/classic
$ docker build --tag apache-activemq:5.15.8 .
```

## Run the Apache ActiveMQ Docker image

Before running the image for the first time, create a Docker *named
volume* so that broker data and configuration are persisted between
runs:

```shell
$ docker volume create apache-activemq-instance
```

Run the ActiveMQ instance, daemonized, with the web admin console port
and all default connector ports (OpenWire, AMQP, MQTT, STOMP,
WebSockets) mapped to the loopback address:
```shell
$ docker run --name apache-activemq --rm -dit -p 127.0.0.1:8161:8161 -p 127.0.0.1:61616:61616 -p 127.0.0.1:5672:5672 -p 127.0.0.1:1883:1883 -p 127.0.0.1:61613:61613 -p 127.0.0.1:61614:61614 -v apache-activemq-instance:/var/opt/apache-activemq/instance apache-activemq:5.15.8
```

Start a Bash shell as the ``activemq`` user in a running container:
```shell
$ docker exec -it apache-activemq bash
```

Stop the ActiveMQ container:
```shell
$ docker attach apache-activemq
^C
```
*(i.e. bring the container to the foreground and then Ctrl-C the process)*

**Note:** ActiveMQ only runs as a background process, so in order to
keep the container running, this image tails the ActiveMQ log in the
background and waits on *that* PID. On the upside, this means that it's
easy to see what's going on in the container by attaching to it; but on
the  downside, it also means that exec'ing ``bin/activemq stop`` will
NOT actually stop the container (only the ActiveMQ process *inside* the
container).

