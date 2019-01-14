FROM centos:7
COPY apache-maven-3.6.0-bin.tar.gz \
     fuse-karaf-7.2.0.fuse-720035-redhat-00001.zip \
     _bashrc.txt \
     setenv.txt \
     /tmp/
LABEL maintainer="Matthew Zipay <mattzATninthtestDOTinfo>"

RUN yum -y update && yum -y upgrade && \
    yum -y install java-1.8.0-openjdk-headless unzip vim-minimal which && \
    rm -rf /var/cache/yum

RUN groupadd -g 59999 fuse && \
    useradd -f -1 -g 59999 -m -u 59999 fuse && \
    cat /tmp/_bashrc.txt >> /home/fuse/.bashrc && \
    rm -f /tmp/_bashrc.txt

RUN mkdir -p /opt && \
    cd /opt && \
    tar zxf /tmp/apache-maven-3.6.0-bin.tar.gz && \
    unzip /tmp/fuse-karaf-7.2.0.fuse-720035-redhat-00001.zip && \
    cat /tmp/setenv.txt >> fuse-karaf-7.2.0.fuse-720035-redhat-00001/bin/setenv && \
    mkdir -p /var/opt/red-hat-fuse/instance && \
    mv fuse-karaf-7.2.0.fuse-720035-redhat-00001/data /var/opt/red-hat-fuse/instance/ && \
    mv fuse-karaf-7.2.0.fuse-720035-redhat-00001/etc /var/opt/red-hat-fuse/instance/ && \
    sed -i.orig \
        -e '/# Disable admin user for the default installation/d' \
	-e 's/#admin =/admin =/' \
	-e 's/#_g_\\:admingroup =/_g_\\:admingroup =/' \
	/var/opt/red-hat-fuse/instance/etc/users.properties && \
    chown -R fuse:fuse /opt/fuse-karaf-7.2.0.fuse-720035-redhat-00001 && \
    chown -R fuse:fuse /var/opt/red-hat-fuse/instance && \
    chmod 0444 /var/opt/red-hat-fuse/instance/etc/users.properties.orig && \
    rm -f /tmp/apache-maven-3.6.0-bin.tar.gz \
        /tmp/fuse-karaf-7.2.0.fuse-720035-redhat-00001.zip \
	/tmp/_bashrc.txt \
	/tmp/setenv.txt

VOLUME /var/opt/red-hat-fuse/instance /opt/fuse-karaf-7.2.0.fuse-720035-redhat-00001/deploy

# 8181 = OSGi HTTP service
# 44444 = Karaf RMI server
# 1099 = Karaf RMI registry
# 8101 = Karaf shell (SSH)
# 61616 = embedded AMQ connector
EXPOSE 8181 44444 1099 8101 61616

USER fuse
WORKDIR /opt/fuse-karaf-7.2.0.fuse-720035-redhat-00001
CMD ["bin/fuse"]

