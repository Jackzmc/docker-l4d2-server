ARG DEBIAN_VERSION=bookworm
FROM debian:$DEBIAN_VERSION-slim

ARG APPID=222860
ARG APPNAME=left4dead2
ARG SERVER_DIR=/server
ARG USER=default

# Install deps
# RUN set -x \
#     && apk update \
#     && apk add --no-cache curl net-tools ca-certificates libstdc++ bash
RUN set -x \
    && apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends --no-install-suggests \
    curl net-tools ca-certificates \
    lib32gcc-s1 \
    libc6-i386 \
    lib32z1
    
# Cleanup
# RUN rm -rf /tmp/* /var/tmp/* && apk --purge del apk-tools
RUN apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add non-root user
RUN adduser $USER

RUN mkdir -p $SERVER_DIR
# Copy external install to image
ADD --chown=$USER srcds_cache $SERVER_DIR
RUN chmod +x $SERVER_DIR/*.sh
# Copy the steamclient from steamcmd to fix steam connection
ADD steamcmd/linux32/steamclient.so /home/$USER/.steam/sdk32/steamclient.so
# Unneeded client media that is on the server
RUN rm -rf $SERVER_DIR/left4dead2*/media 


USER $USER

ENV APPID=$APPID
ENV APPNAME=$APPNAME
ENV SERVER_DIR=$SERVER_DIR
ENV PATH="$PATH:$SERVER_DIR"

EXPOSE 27015/udp

WORKDIR $SERVER_DIR
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["./srcds_run", "-game", "left4dead2"]
