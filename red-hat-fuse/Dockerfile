FROM centos:7
LABEL maintainer="Matthew Zipay <mattzATninthtestDOTinfo>"

RUN yum -y update && yum -y upgrade && \
    yum -y install java-1.8.0-openjdk-headless unzip vim-minimal which && \
    rm -rf /var/cache/yum

RUN groupadd -g 59999 fuse && \
    useradd -f -1 -g 59999 -m -u 59999 fuse

COPY fuse-*.zip /tmp/
RUN cd /opt && \
    unzip /tmp/fuse-*.zip && \
    chmod -R g-w,o-rwxXst fuse-* && \
    chown -R fuse:fuse fuse-* && \
    ln -s fuse-* fuse && \
    chmod -x fuse/bin/contrib/*.* && \
    chmod ug+x fuse/bin/contrib/*.sh fuse/bin/contrib/*.init* && \
    rm -rf fuse/data fuse/deploy && \
    mkdir -m 0750 /var/opt/fuse && \
    mkdir -m 0750 /var/opt/fuse/bin && \
    mkdir -m 0750 /var/opt/fuse/data && \
    mkdir -m 0770 /var/opt/fuse/deploy && \
    cp fuse/bin/setenv /var/opt/fuse/bin/ && \
    echo -e '#!/bin/sh\n\ntest -f /var/opt/fuse/bin/setenv && . /var/opt/fuse/bin/setenv' >fuse/bin/setenv && \
    mv fuse/etc /var/opt/fuse/ && \
    sed -i.orig \
        -e 's/\(karaf\.shutdown\.port\.file\)\s*=\s*.*\/\(.*\)/\1 = \/var\/opt\/fuse\/\2/' \
        -e 's/\(karaf\.pid\.file\)\s*=\s*.*\/\(.*\)/\1 = \/var\/opt\/fuse\/\2/' \
        /var/opt/fuse/etc/config.properties && \
    sed -i.orig \
        's/\(felix\.fileinstall\.dir\)\s*=.*/\1 = \/var\/opt\/fuse\/deploy/' \
        /var/opt/fuse/etc/org.apache.felix.fileinstall-deploy.cfg && \
    sed -i.orig \
        '/# karaf.lock.dir=/a karaf.lock.dir = \/var\/opt\/fuse' \
        /var/opt/fuse/etc/system.properties && \
    sed -i.orig \
        -e '/# Disable admin user for the default installation/d' \
	-e 's/#admin =/admin =/' \
	-e 's/#_g_\\:admingroup =/_g_\\:admingroup =/' \
	/var/opt/fuse/etc/users.properties && \
    chmod 0440 /var/opt/fuse/etc/*.orig && \
    chown -R fuse:fuse /var/opt/fuse && \
    echo "umask 0027" >> /home/fuse/.bashrc && \
    rm -f /tmp/*.*

COPY --chown=fuse:fuse docker-fuse-entrypoint.sh /

ENV PS1="[\u@\h:\w]\n\$ " \
    EDITOR="vi" \
    JAVA_HOME="/etc/alternatives/jre_1.8.0_openjdk" \
    KARAF_HOME="/opt/fuse" \
    KARAF_DATA="/var/opt/fuse/data" \
    KARAF_ETC="/var/opt/fuse/etc" \
    KARAF_NOROOT="true" \
    KARAF_OPTS="-Dkaraf.instances=/var/opt/fuse/instances" \
    MAVEN_HOME="/opt/maven" \
    MAVEN_REPO="/var/opt/fuse/data/repository" \
    PATH="$PATH:/etc/alternatives/jre_1.8.0_openjdk:/opt/fuse/bin"

VOLUME /var/opt/fuse

# 8181 = OSGi HTTP service
# 8101 = Karaf shell (SSH)
# 44444 = Karaf RMI server
# 1099 = Karaf RMI registry
# 5005 = Karaf debug
# 61616 = embedded AMQ connector
EXPOSE 8181 8101 44444 1099 5005 61616

USER fuse
WORKDIR /var/opt/fuse
CMD ["/opt/fuse/bin/fuse"]

