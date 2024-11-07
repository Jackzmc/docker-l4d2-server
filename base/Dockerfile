FROM debian:12

ARG APPID=222860
ARG APPNAME=left4dead2
ARG SERVER_DIR=/server

# Install deps
RUN set -x \
    && apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install --no-install-recommends --no-install-suggests \
        curl net-tools ca-certificates \
        lib32gcc-s1 \
        libc6-i386 \
        lib32z1

# Cleanup
RUN apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir -p $SERVER_DIR
# Copy external install to image
ADD --chown=$USER srcds_cache $SERVER_DIR
# Copy the steamclient from steamcmd to fix steam connection
ADD steamcmd/linux32/steamclient.so /root/.steam/sdk32/steamclient.so

RUN chmod +x $SERVER_DIR/*.sh

ENV LD_LIBRARY_PATH=.:bin:$LD_LIBRARY_PATH
ENV APPID=$APPID
ENV APPNAME=$APPNAME
ENV SERVER_DIR=$SERVER_DIR
ENV PATH="$PATH:$SERVER_DIR"

EXPOSE 27015/udp

WORKDIR $SERVER_DIR
ENTRYPOINT ["/bin/bash", "-c"]
CMD [""]
