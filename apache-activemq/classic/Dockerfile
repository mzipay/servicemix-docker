FROM centos:7
COPY apache-activemq-5.15.8-bin.tar.gz \
     _bashrc.txt \
     activemq-startwait.sh \
     /tmp/
LABEL maintainer="Matthew Zipay <mattzATninthtestDOTinfo>"

RUN yum -y update && yum -y upgrade && \
    yum -y install java-1.8.0-openjdk-headless vim-minimal which && \
    rm -rf /var/cache/yum

RUN groupadd -g 59999 activemq && \
    useradd -f -1 -g 59999 -m -u 59999 activemq && \
    cat /tmp/_bashrc.txt >> /home/activemq/.bashrc && \
    rm -f /tmp/_bashrc.txt

RUN mkdir -p /opt && \
    cd /opt && \
    tar zxf /tmp/apache-activemq-5.15.8-bin.tar.gz && \
    mkdir -p /var/opt/apache-activemq/instance/tmp && \
    mv apache-activemq-5.15.8/conf /var/opt/apache-activemq/instance/ && \
    mv apache-activemq-5.15.8/data /var/opt/apache-activemq/instance/ && \
    sed -i.orig \
        -e '/# ACTIVEMQ_BASE="\$ACTIVEMQ_HOME"/a ACTIVEMQ_INST="\/var\/opt\/apache-activemq\/instance"' \
	-e '/# ACTIVEMQ_CONF="\$ACTIVEMQ_BASE\/conf"/a ACTIVEMQ_CONF="\$ACTIVEMQ_INST\/conf"' \
	-e '/# ACTIVEMQ_DATA="\$ACTIVEMQ_BASE\/data"/a ACTIVEMQ_DATA="\$ACTIVEMQ_INST\/data"' \
	-e '/# ACTIVEMQ_TMP="\$ACTIVEMQ_BASE\/tmp"/a ACTIVEMQ_TMP="\$ACTIVEMQ_INST\/tmp"' \
	-e 's/# ACTIVEMQ_PIDFILE=/ACTIVEMQ_PIDFILE=/' \
	-e 's/ACTIVEMQ_USER=""/ACTIVEMQ_USER="activemq"/' \
	-e '/#JAVA_HOME=""/a JAVA_HOME="\/etc\/alternatives\/jre_1.8.0_openjdk"' \
	-e 's/JAVACMD="auto"/#JAVACMD="auto"/' \
	apache-activemq-5.15.8/bin/env && \
    mv /tmp/activemq-startwait.sh /var/opt/apache-activemq/instance/ && \
    chown -R activemq:activemq /opt/apache-activemq-5.15.8 && \
    chmod 0444 /opt/apache-activemq-5.15.8/bin/env.orig && \
    chown -R activemq:activemq /var/opt/apache-activemq/instance && \
    rm -f /tmp/apache-activemq-5.15.8-bin.tar.gz

VOLUME /var/opt/apache-activemq/instance

# 8161 = ActiveMQ web admin console
# 61616 = OpenWire/AMQP/MQTT/STOMP
# 5672 = AMQP
# 1883 = MQTT
# 61613 = STOMP
# 61614 = WebSockets
EXPOSE 8161 61616 5672 1883 61613 61614

USER activemq
WORKDIR /opt/apache-activemq-5.15.8
CMD ["/var/opt/apache-activemq/instance/activemq-startwait.sh"]

