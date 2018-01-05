#!/bin/bash

#Note NIFI_HOME and NIFI_WEB_PORT are set in the dockerfile script

nifi_props_file=${NIFI_HOME}/conf/nifi.properties
nifi_authorizers_file={NIFI_HOME}/conf/authorizers.xml

# Set the web port property to the value defined for the docker container 
sed -i -e 's|nifi.web.http.port=.*$|nifi.web.http.port='${NIFI_WEB_PORT}'|' ${nifi_props_file}

# Set the site-to-site port property to the value defined for the docker container 
sed -i -e 's|nifi.remote.input.socket.port=.*$|nifi.remote.input.socket.port='${NIFI_SITE_TO_SITE_PORT}'|' ${nifi_props_file}

# start NIFI 
${NIFI_HOME}/bin/nifi.sh run

