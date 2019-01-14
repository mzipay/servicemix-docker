FROM centos:7
COPY apache-maven-3.6.0-bin.tar.gz \
     apache-servicemix-7.0.1.zip \
     _bashrc.txt \
     setenv.txt \
     /tmp/
LABEL maintainer="Matthew Zipay <mattzATninthtestDOTinfo>"

RUN yum -y update && yum -y upgrade && \
    yum -y install java-1.8.0-openjdk-headless unzip vim-minimal which && \
    rm -rf /var/cache/yum

RUN groupadd -g 59999 servicemix && \
    useradd -f -1 -g 59999 -m -u 59999 servicemix && \
    cat /tmp/_bashrc.txt >> /home/servicemix/.bashrc && \
    rm -f /tmp/_bashrc.txt

RUN mkdir -p /opt && \
    cd /opt && \
    tar zxf /tmp/apache-maven-3.6.0-bin.tar.gz && \
    unzip /tmp/apache-servicemix-7.0.1.zip && \
    cat /tmp/setenv.txt >> apache-servicemix-7.0.1/bin/setenv && \
    mkdir -p /var/opt/apache-servicemix/instance && \
    mv apache-servicemix-7.0.1/data /var/opt/apache-servicemix/instance/ && \
    mv apache-servicemix-7.0.1/etc /var/opt/apache-servicemix/instance/ && \
    chown -R servicemix:servicemix /opt/apache-servicemix-7.0.1 && \
    chown -R servicemix:servicemix /var/opt/apache-servicemix/instance && \
    rm -f /tmp/apache-* /tmp/setenv.txt

VOLUME /var/opt/apache-servicemix/instance /opt/apache-servicemix-7.0.1/deploy

# 8181 = OSGi HTTP service
# 8443 = OSGi HTTPS service
# 44444 = Karaf RMI server
# 1099 = Karaf RMI registry
# 8101 = Karaf shell (SSH)
# 61616 = embedded ActiveMQ connector
EXPOSE 8181 8443 44444 1099 8101 61616

USER servicemix
WORKDIR /opt/apache-servicemix-7.0.1
CMD ["bin/servicemix"]

