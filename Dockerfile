FROM       openjdk:alpine
MAINTAINER Alex Tilcock <a_tilcock@hotmail.com>

ARG        DIST_MIRROR=http://archive.apache.org/dist/nifi
ARG        VERSION=1.5.0

ENV        NIFI_HOME=/opt/nifi 
ENV        NIFI_WEB_PORT=8080
ENV        NIFI_SITE_TO_SITE_PORT=8081


RUN        apk update && apk add --upgrade bash curl openjdk8 && \
           mkdir -p ${NIFI_HOME} && \
           curl ${DIST_MIRROR}/${VERSION}/nifi-${VERSION}-bin.tar.gz | tar xvz -C ${NIFI_HOME} && \
           mv ${NIFI_HOME}/nifi-${VERSION}/* ${NIFI_HOME} && \
           rm -rf ${NIFI_HOME}/nifi-${VERSION} && \
           rm -rf *.tar.gz && \
           rm -rf /var/cache/apk/*

EXPOSE     8080 8081 8443
VOLUME     ${NIFI_HOME}/logs \
           ${NIFI_HOME}/flowfile_repository \
           ${NIFI_HOME}/database_repository \
           ${NIFI_HOME}/content_repository \
           ${NIFI_HOME}/provenance_repository


# copy db drivers required for NIFI SQL processors
ADD             ./DBDrivers/ /opt/dbdrivers

#copy utility scripts
ADD             ./xsltfiles /opt/xsltfiles

#copy custom nar files 
ADD             ./lib ${NIFI_HOME}/lib

ADD             ./scripts  /opt/scripts

RUN             chmod +x /opt/scripts/startup.sh

CMD             ./opt/scripts/startup.sh

#CMD             ${NIFI_HOME}/bin/nifi.sh run  



