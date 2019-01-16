FROM centos:7
LABEL maintainer="Matthew Zipay <mattzATninthtestDOTinfo>"

RUN yum -y update && yum -y upgrade && \
    yum -y install java-1.8.0-openjdk-headless unzip vim-minimal which && \
    rm -rf /var/cache/yum

RUN groupadd -g 59999 servicemix && \
    useradd -f -1 -g 59999 -m -u 59999 servicemix

COPY apache-servicemix-*.zip apache-maven-*.tar.gz /tmp/
RUN cd /opt && \
    unzip /tmp/apache-servicemix-*.zip && \
    tar zxf /tmp/apache-maven-*.tar.gz && \
    chmod -R g-w,o-rwxXst apache-servicemix-* apache-maven-* && \
    chown -R servicemix:servicemix apache-servicemix-* apache-maven-* && \
    ln -s apache-servicemix-* servicemix && \
    ln -s apache-maven-* maven && \
    rm -rf servicemix/data servicemix/deploy && \
    mkdir -m 0750 /var/opt/servicemix && \
    mkdir -m 0750 /var/opt/servicemix/data && \
    mkdir -m 0770 /var/opt/servicemix/deploy && \
    mkdir -m 0750 /var/opt/servicemix/local && \
    mv servicemix/etc /var/opt/servicemix/ && \
    sed -i.orig \
        -e 's/\(karaf\.shutdown\.port\.file\)\s*=\s*.*\/\(.*\)/\1 = \/var\/opt\/servicemix\/\2/' \
        -e 's/\(karaf\.pid\.file\)\s*=\s*.*\/\(.*\)/\1 = \/var\/opt\/servicemix\/\2/' \
        /var/opt/servicemix/etc/config.properties && \
    sed -i.orig \
        's/\(felix\.fileinstall\.dir\)\s*=.*/\1 = \/var\/opt\/servicemix\/deploy/' \
        /var/opt/servicemix/etc/org.apache.felix.fileinstall-deploy.cfg && \
    sed -i.orig \
        '/# karaf.lock.dir=/a karaf.lock.dir = \/var\/opt\/servicemix' \
        /var/opt/servicemix/etc/system.properties && \
    chmod 0440 /var/opt/servicemix/etc/*.orig && \
    chown -R servicemix:servicemix /var/opt/servicemix && \
    cp -R maven/conf /home/servicemix/.m2 && \
    chown -R servicemix:servicemix /home/servicemix/.m2 && \
    sed -i.orig '/<localRepository>\/path\/to\/local\/repo<\/localRepository>/,/\-\->/!b;/\-\->/a <localRepository>\/var\/opt\/servicemix\/local<\/localRepository>' /home/servicemix/.m2/settings.xml && \
    chmod 0440 /home/servicemix/.m2/settings.xml.orig && \
    rm -f /tmp/*.*

COPY --chown=servicemix:servicemix docker-servicemix-entrypoint.sh /

ENV PS1="[\u@\h:\w]\n\$ " \
    EDITOR="vi" \
    JAVA_HOME="/etc/alternatives/jre_1.8.0_openjdk" \
    KARAF_HOME="/opt/servicemix" \
    KARAF_DATA="/var/opt/servicemix/data" \
    KARAF_ETC="/var/opt/servicemix/etc" \
    KARAF_NOROOT="true" \
    KARAF_OPTS="-Dkaraf.instances=/var/opt/servicemix/instances" \
    MAVEN_HOME="/opt/maven" \
    MAVEN_REPO="/var/opt/servicemix/local" \
    PATH="$PATH:/etc/alternatives/jre_1.8.0_openjdk/bin:/opt/maven/bin:/opt/servicemix/bin"

VOLUME /var/opt/servicemix

# 8181 = OSGi HTTP service
# 8101 = Karaf shell (SSH)
# 44444 = Karaf RMI server
# 1099 = Karaf RMI registry
# 61616 = embedded ActiveMQ connector
EXPOSE 8181 8101 44444 1099 61616

USER servicemix
WORKDIR /var/opt/servicemix
CMD ["/docker-servicemix-entrypoint.sh"]

