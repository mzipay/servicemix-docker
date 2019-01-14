FROM openjdk:11-jre-slim-stretch
COPY apache-artemis-2.6.3-bin.tar.gz \
     _bashrc.txt \
     /tmp/
LABEL maintainer="Matthew Zipay <mattzATninthtestDOTinfo>"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get install -y libaio1 && \
    apt-get install -y --no-install-recommends vim-tiny && \
    apt-get clean

RUN mkdir -p /opt && \
    cd /opt && \
    tar zxf /tmp/apache-artemis-2.6.3-bin.tar.gz && \
    rm -f /tmp/apache-artemis-2.6.3-bin.tar.gz

RUN addgroup --gid 59999 artemis && \
    adduser --uid 59999 --gid 59999 --disabled-password \
        --gecos 'Apache ActiveMQ Artemis' artemis && \
    cat /tmp/_bashrc.txt >> /home/artemis/.bashrc && \
    rm -f /tmp/_bashrc.txt

# Note: Setting '--http-host 0.0.0.0' is needed so that
#       "-p 127.0.0.1:8161:8161" will actually allow access to the
#       Hawtio console
RUN mkdir -p /var/opt/apache-artemis && \
    chown artemis:artemis /var/opt/apache-artemis && \
    cd /var/opt/apache-artemis && \
    JAVA_HOME=$(/usr/local/bin/docker-java-home) \
        runuser -u artemis -g artemis --preserve-environment -- \
            /opt/apache-artemis-2.6.3/bin/artemis \
	    create /var/opt/apache-artemis/broker \
            --aio \
            --user admin \
	    --password passw0rd \
	    --require-login \
	    --http-host 0.0.0.0

VOLUME /var/opt/apache-artemis/broker

# 8161 = Hawtio
# 61616 = OpenWire/AMQP/MQTT/STOMP
# 5672 = AMQP
# 1883 = MQTT
# 61613 = STOMP
EXPOSE 8161 61616 5672 1883 61613

USER artemis
WORKDIR /var/opt/apache-artemis/broker
CMD ["bin/artemis", "run", "--allow-kill"]

