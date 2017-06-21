FROM lsiobase/xenial

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

# install packages
RUN \
 echo "deb http://www.ubnt.com/downloads/unifi/debian unifi5 ubiquiti" >> /etc/apt/sources.list && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 && \
 #apt-get update && \
 apt-get install -y \
	execstack \
	openjdk-8-jre-headless \
	wget \
	binutils \
	mongodb-server \
	jsvc && \
	# unifi \
# NEW
 wget -O /tmp/unifi_sysvinit_all.deb \
	https://www.ubnt.com/downloads/unifi/5.5.11-5107276ec2/unifi_sysvinit_all.deb && \
    dpkg --install /tmp/unifi_sysvinit_all.deb && \
    rm -rf /tmp/unifi_sysvinit_all.deb && \
    #rm -rf /tmp/unifi_sysvinit_all.deb #/var/lib/unifi/*	
# fix execstack warning on library
 execstack -c \
	/usr/lib/unifi/lib/native/Linux/amd64/libubnt_webrtc_jni.so && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# Volumes and Ports
WORKDIR /usr/lib/unifi
VOLUME /config
EXPOSE 8080 8081 8443 8843 8880
