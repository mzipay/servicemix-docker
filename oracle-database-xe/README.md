# Oracle Database XE

**DISCLAIMER:** *THIS IMAGE IS INTENDED FOR LOCAL
DEVELOPMENT/EDUCATIONAL USE __ONLY__ AND IS __NOT SUITABLE__ FOR
DEPLOYMENT OF ANY KIND WITHOUT SUBSTANTIAL MODIFICATION.*

**ATTENTION:** *ALL EXPOSED PORTS SHOULD BE MAPPED EXPLICITLY TO THE
HOST LOOPBACK ADDRESS. DEVIATE FROM THIS AT YOUR OWN PERIL!*

------------------------------------------------------------------------

The official Oracle Database XE image is based on Oracle Linux 7 (slim).

## Build the Oracle Database XE Docker image

Start with the official Oracle Database XE image from
oracle/docker-images:

```shell
$ git clone https://github.com/oracle/docker-images.git
```

Download the [Oracle XE 18c RPM](
https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html)
(requires registration) into the
*docker-images/OracleDatabase/SingleInstance/dockerfiles/18.4.0/*
directory, then build the base image:

```shell
$ mv oracle-database-xe-18c-1.0-1.x86_64.rpm docker-images/OracleDatabase/SingleInstance/dockerfiles/18.4.0/
$ cd docker-images/OracleDatabase/SingleInstance/dockerfiles
$ ./buildDockerImage.sh -v 18.4.0 -x
```

This creates the *oracle/database:18.4.0-xe* image in the local Docker
server. The database itself still needs to be created, which happens on
the first run. The official *Dockerfile.xe* defines a volume for the
Oracle instance data, so create a *named volume* to hold that data
before beginning database creation. Declare another volume for this
project's *setup/* directory to get some additional packages and
configuration (see the **Custom configuration** subsection below for
details):

```shell
$ cd /your/development/area
$ git clone https://github.com/mzipay/servicemix-docker.git
$ cd servicemix-docker/oracle-database-xe
$ docker volume create oracle-xe-oradata
$ docker run --rm -it -e ORACLE_PWD=******** -e ORACLE_CHARACTERSET=AL32UTF8 -v $(pwd)/setup:/opt/oracle/scripts/setup -v oracle-xe-oradata:/opt/oracle/oradata oracle/database:18.4.0-xe
```

If database creation is successful, the following message is displayed:

> #########################
> DATABASE IS READY TO USE!
> #########################

__IMPORTANT!__

With the container **still running**, commit the changes to a new image.
Without this step, the database creation and configuration will be lost!
A different name and tag should be chosen on the commit so that
additional images with different database configurations may be created
without the need to re-create the official base image. For example:

```shell
$ docker commit 0eaa614599d2 oracle-database-xe:18c
```

### Custom configuration

The *setup/* directory contains shell scripts (\*.sh) and PL\*SQL
scripts (\*.sql) that will be automatically executed following database
creation. These scripts perform several useful (IMO) steps:

+ install the ``socat``, ``vim-minial`` and ``which`` packages
+ disable Oracle password expiration
+ enable remote access for EM Express (port 5500)
+ export PS1, EDITOR and a "sqlplus" function alias from the ``oracle``
  user's *.bashrc*

The ``socat`` and ``vim-minimal`` packages, combined with the EDITOR
environment variable and the "sqlplus" function alias, transform
``sqlplus`` from a frustratingly crippled throw-away into a
pretty-darn-useful utility.

Of course, you're free to dispense with these additions (just remove
"-v ./setup:/opt/oracle/scripts/setup" when running the image for the
first time) or customize them in any way you'd like.

## Run the Oracle Database XE Docker image

Run a daemonized database container with the TNS listener port mapped to
the loopback address:
```shell
$ docker run --name oracle-xe --rm -dit -p 127.0.0.1:1521:1521 -v oracle-xe-oradata:/opt/oracle/oradata oracle-database-xe:18c
```

Start a Bash shell in the running database container:
```shell
$ docker exec -it -u oracle oracle-xe bash
```

Start a sqlplus session in the running database container:
```shell
$ docker exec -it -u oracle oracle-xe sqlplus
```

Stop the database container:
```shell
$ docker attach oracle-xe
^C
```
*(i.e. bring the container to the foreground and then Ctrl-C the process)*

