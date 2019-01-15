FROM openjdk:8-jre-alpine
LABEL maintainer="Matthew Zipay <mattzATninthtestDOTinfo>"

RUN apk update && \
    apk upgrade && \
    apk --no-cache add su-exec && \
    rm -rf /var/cache/apk/*

RUN addgroup -g 59999 karaf && \
    adduser -g "Apache Karaf" -s /bin/ash -G karaf -D -u 59999 karaf

ADD apache-karaf-* apache-maven-* /opt/
RUN cd /opt && \
    chmod -R g-w,o-rwxXst apache-karaf-* apache-maven-* && \
    chown -R karaf:karaf apache-karaf-* apache-maven-* && \
    ln -s apache-karaf-* karaf && \
    ln -s apache-maven-* maven && \
    chmod -x karaf/bin/contrib/*.* && \
    chmod ug+x karaf/bin/contrib/*.sh karaf/bin/contrib/*.init* && \
    rm -rf karaf/data karaf/deploy && \
    mkdir -m 0750 /var/opt/karaf && \
    mkdir -m 0750 /var/opt/karaf/data && \
    mkdir -m 0770 /var/opt/karaf/deploy && \
    mkdir -m 0750 /var/opt/karaf/local && \
    mv karaf/etc /var/opt/karaf/ && \
    sed -i.orig \
        -e 's/\(karaf\.shutdown\.port\.file\)\s*=\s*.*\/\(.*\)/\1 = \/var\/opt\/karaf\/\2/' \
        -e 's/\(karaf\.pid\.file\)\s*=\s*.*\/\(.*\)/\1 = \/var\/opt\/karaf\/\2/' \
        /var/opt/karaf/etc/config.properties && \
    sed -i.orig \
        's/\(felix\.fileinstall\.dir\)\s*=.*/\1 = \/var\/opt\/karaf\/deploy/' \
	/var/opt/karaf/etc/org.apache.felix.fileinstall-deploy.cfg && \
    sed -i.orig \
        '/# karaf.lock.dir=/a karaf.lock.dir = \/var\/opt\/karaf' \
	/var/opt/karaf/etc/system.properties && \
    chmod 0440 /var/opt/karaf/etc/*.orig && \
    chown -R karaf:karaf /var/opt/karaf && \
    cp -R maven/conf /home/karaf/.m2 && \
    chown -R karaf:karaf /home/karaf/.m2 && \
    sed -i.orig '/<localRepository>\/path\/to\/local\/repo<\/localRepository>/,/\-\->/!b;/\-\->/a <localRepository>\/var\/opt\/karaf\/local<\/localRepository>' /home/karaf/.m2/settings.xml && \
    chmod 0440 /home/karaf/.m2/settings.xml.orig

COPY --chown=karaf:karaf docker-karaf-entrypoint.sh /

ENV PS1="[\u@\h:\w]\n\$ " \
    EDITOR="vi" \
    KARAF_HOME="/opt/karaf" \
    KARAF_DATA="/var/opt/karaf/data" \
    KARAF_ETC="/var/opt/karaf/etc" \
    KARAF_NOROOT="true" \
    KARAF_OPTS="-Dkaraf.instances=/var/opt/karaf/instances" \
    MAVEN_HOME="/opt/maven" \
    MAVEN_REPO="/var/opt/karaf/local" \
    PATH="$PATH:/opt/maven/bin:/opt/karaf/bin"

VOLUME /var/opt/karaf

# 8181 = OSGi HTTP service
# 8101 = Karaf shell (SSH)
# 44444 = Karaf RMI server
# 1099 = Karaf RMI registry
EXPOSE 8181 8101 44444 1099

USER karaf
WORKDIR /var/opt/karaf
ENTRYPOINT ["/docker-karaf-entrypoint.sh"]

