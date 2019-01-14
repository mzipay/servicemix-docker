FROM openjdk:8-jre-alpine
COPY apache-apollo-1.7.1-unix-distro.tar.gz \
     _ashrc.txt \
     /tmp/
LABEL maintainer="Matthew Zipay <mattzATninthtestDOTinfo>"

RUN apk update && apk upgrade && apk --no-cache add su-exec

RUN mkdir -p /opt && \
    cd /opt && \
    tar zxf /tmp/apache-apollo-1.7.1-unix-distro.tar.gz && \
    rm -f /tmp/apache-apollo-1.7.1-unix-distro.tar.gz

RUN addgroup -g 59999 apollo && \
    adduser -g "Apache ActiveMQ Apollo" -s /bin/ash -G apollo -D -u 59999 apollo && \
    cat /tmp/_ashrc.txt >> /home/apollo/.ashrc && \
    rm -f /tmp/_ashrc.txt && \
    chown apollo:apollo /home/apollo/.ashrc

# Note: default account is admin/password
RUN mkdir -p /var/opt/apache-apollo && \
    chown apollo:apollo /var/opt/apache-apollo && \
    cd /var/opt/apache-apollo && \
    JAVA_HOME=$(/usr/local/bin/docker-java-home) \
        su-exec apollo:apollo /opt/apache-apollo-1.7.1/bin/apollo create broker

RUN su-exec apollo:apollo \
        /var/opt/apache-apollo/broker/bin/apollo-broker run &>/dev/null & apollopid=$!; \
    sleep 5; \
    timeout -t 45 /bin/sh -c 'while ! test -s /var/opt/apache-apollo/broker/etc/apollo.xml; do sleep 5; done'; \
    test -s /var/opt/apache-apollo/broker/etc/apollo.xml && \
    su-exec apollo:apollo \
        sed -i.orig 's/127.0.0.1:6168/0.0.0.0:6168/g' /var/opt/apache-apollo/broker/etc/apollo.xml || \
    (>&2 echo "Apollo web admin may not accessible from host -- check etc/apollo.xml <web_admin>"); \
    kill -s SIGINT $apollopid

VOLUME /var/opt/apache-apollo/broker

# 61680 = HTTP admin interface
# 61681 = HTTPS admin interface
# 61613 = OpenWire/AMQP/MQTT/STOMP (TCP)
# 61614 = OpenWire/AMQP/MQTT/STOMP (TCP+TLS)
# 61623 = HTTP WebSockets
# 61624 = HTTPS WebSockets
EXPOSE 61680 61681 61613 61614 61623 61624

ENV ENV="/home/apollo/.ashrc"
USER apollo
WORKDIR /var/opt/apache-apollo/broker
CMD ["bin/apollo-broker", "run"]

