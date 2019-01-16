FROM openjdk:8-jre-alpine
LABEL maintainer="Matthew Zipay <mattzATninthtestDOTinfo>"

RUN apk update && \
    apk upgrade && \
    apk --no-cache add su-exec && \
    rm -rf /var/cache/apk/*

RUN addgroup -g 65521 archiva && \
    adduser -g "Apache Archiva" -s /bin/ash -G archiva -D -u 65521 archiva

COPY archiva.nowrapper /tmp/
ADD apache-archiva-* /opt/
RUN cd /opt && \
    chmod -R g-w,o-rwxXst apache-archiva-* && \
    chown -R archiva:archiva apache-archiva-* && \
    ln -s apache-archiva-* archiva && \
    chmod -x archiva/lib/*.* && \
    chmod -x archiva/bin/* && \
    mv archiva/bin/archiva archiva/bin/archiva.orig && \
    chmod 0440 archiva/bin/archiva.orig && \
    mv /tmp/archiva.nowrapper archiva/bin/archiva && \
    chown archiva:archiva archiva/bin/archiva && \
    chmod 0750 archiva/bin/archiva && \
    mkdir -m 0750 /var/opt/archiva && \
    mv archiva/conf archiva/contexts archiva/logs archiva/temp /var/opt/archiva/ && \
    mv archiva/apps /srv/ && \
    sed -i.orig \
        -e 's|<SystemProperty name="jetty\.home" default="\."/>/contexts|/var/opt/archiva/contexts|g' \
        -e 's|<SystemProperty name="jetty\.home" default="\."/>/apps|/srv/apps|g' \
        /var/opt/archiva/conf/jetty.xml && \
    sed -i.orig \
        -e 's|<Set name="contextPath">/</Set>|<Set name="contextPath">/archiva</Set>|' \
        -e 's|<SystemProperty name="jetty\.home" default="\."/>/apps|/srv/apps|' \
	/var/opt/archiva/contexts/archiva.xml && \
    find /var/opt/archiva -name "*.orig" | xargs chmod 0440 && \
    chown -R archiva:archiva /var/opt/archiva /srv/apps

COPY --chown=archiva:archiva docker-archiva-entrypoint.sh /

ENV PS1="[\u@\h:\w]\n\$ " \
    EDITOR="vi" \
    ARCHIVA_HOME="/opt/archiva" \
    ARCHIVA_BASE="/var/opt/archiva"

VOLUME /var/opt/archiva

# 8080 = HTTP application
# 8443 = HTTPS application
# 9160 = Apache Cassandra
EXPOSE 8080 8443 9160

USER archiva
WORKDIR /var/opt/archiva
ENTRYPOINT ["/docker-archiva-entrypoint.sh"]

