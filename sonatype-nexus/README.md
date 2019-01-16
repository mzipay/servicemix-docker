# Sonatype Nexus Repository Manager (NXRM) OSS

**DISCLAIMER:** *THIS IMAGE IS INTENDED FOR LOCAL
DEVELOPMENT/EDUCATIONAL USE __ONLY__ AND IS __NOT SUITABLE__ FOR
DEPLOYMENT OF ANY KIND WITHOUT SUBSTANTIAL MODIFICATION.*

**ATTENTION:** *ALL EXPOSED PORTS SHOULD BE MAPPED EXPLICITLY TO THE
HOST LOOPBACK ADDRESS. DEVIATE FROM THIS AT YOUR OWN PERIL!*

------------------------------------------------------------------------

Use an official Sonatype Nexus Repository Manager (NXRM) OSS image from
[sonatype/nexus3 on Docker Hub](
https://hub.docker.com/r/sonatype/nexus3), or use the *Dockerfile* from
[sonatype/docker-nexus3 on GitHub](
https://github.com/sonatype/docker-nexus3).

**Note:** NXRM OSS does not support running on OpenJDK (see [NEXUS-7841](
https://issues.sonatype.org/browse/NEXUS-7841).

## Run the Sonatype Nexus Repository Manager (NXRM) OSS Docker image

First create a Docker *named volume* to persist the configuration and
storage:

```shell
$ docker volume create nexus-data
```

Run a repository container with the application port mapped to the
loopback address:
```shell
$ docker run --name nexus -d -p 127.0.0.1:8081:8081 -e NEXUS_CONTEXT=nexus -v nexus-data:/nexus-data sonatype/nexus3:3.15.0
```
*(The application is now available at http://127.0.0.1:8081/nexus. The
default login is admin/admin123.)

