FROM centos:7
LABEL maintainer="Matthew Zipay <mattzATninthtestDOTinfo>"

RUN yum -y update && yum -y upgrade && \
    yum -y install java-1.8.0-openjdk-headless unzip vim-minimal which && \
    rm -rf /var/cache/yum

RUN groupadd -g 59999 fuse && \
    useradd -f -1 -g 59999 -m -u 59999 fuse

COPY jboss-fuse-karaf-*.zip /tmp/
RUN cd /opt && \
    unzip /tmp/jboss-fuse-karaf-*.zip && \
    chmod -R g-w,o-rwxXst jboss-fuse-* && \
    chmod -R u+x,g+x jboss-fuse-*/bin && \
    chown -R fuse:fuse jboss-fuse-* && \
    ln -s jboss-fuse-* fuse && \
    sed -i.orig \
	-e 's/^#admin=/admin=/' \
	/opt/fuse/etc/users.properties && \
    chmod 0440 /opt/fuse/etc/*.orig && \
    chown -R fuse:fuse /opt/fuse && \
    rm -f /tmp/*.*

ENV PS1="[\u@\h:\w]\n\$ " \
    EDITOR="vi" \
    JAVA_HOME="/etc/alternatives/jre_1.8.0_openjdk" \
    KARAF_HOME="/opt/fuse" \
    KARAF_NOROOT="true" \
    PATH="$PATH:/etc/alternatives/jre_1.8.0_openjdk:/opt/fuse/bin"

VOLUME ["/opt/fuse/bin", "/opt/fuse/data", "/opt/fuse/deploy", "/opt/fuse/etc"]

# 8181 = OSGi HTTP service
# 8101 = Karaf shell (SSH)
# 44444 = Karaf RMI server
# 1099 = Karaf RMI registry
# 5005 = Karaf debug
# 61616 = embedded AMQ connector
EXPOSE 8181 8101 44444 1099 5005 61616

USER fuse
WORKDIR /home/fuse
CMD ["/opt/fuse/bin/fuse"]

