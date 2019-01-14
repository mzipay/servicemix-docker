#!/usr/bin/env bash

cd /opt/apache-activemq-5.15.8

./bin/activemq start && sleep 3
tail -F /var/opt/apache-activemq/instance/data/activemq.log & wait $!
./bin/activemq stop

exit $?

