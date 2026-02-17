ARG DEBIAN_VERSION=bookworm
FROM debian:$DEBIAN_VERSION-slim

ARG APPID=222860
ARG APPNAME=left4dead2
ARG SERVER_DIR=/server
ARG USER=steam

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
    lib32z1 \
    lib32stdc++6 
    
# Cleanup
# RUN rm -rf /tmp/* /var/tmp/* && apk --purge del apk-tools
RUN apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add non-root user
RUN addgroup --gid 1003 $USER && adduser --uid 1003 --gid 1003 $USER

RUN mkdir -p $SERVER_DIR

# Copy external install to image
COPY ./srcds_cache/srcds_linux \
    ./srcds_cache/srcds_run \
    ./srcds_cache/steam_appid.txt \
    ./srcds_cache/left4dead2.dat $SERVER_DIR/
COPY ./srcds_cache/bin $SERVER_DIR/bin
COPY ./srcds_cache/hl2 $SERVER_DIR/hl2
COPY ./srcds_cache/platform $SERVER_DIR/platform
COPY ./srcds_cache/update $SERVER_DIR/update
COPY --exclude=media ./srcds_cache/left4dead2 $SERVER_DIR/left4dead2
COPY ./srcds_cache/left4dead2_dlc1 $SERVER_DIR/left4dead2_dlc1
COPY ./srcds_cache/left4dead2_dlc2 $SERVER_DIR/left4dead2_dlc2
COPY ./srcds_cache/left4dead2_dlc3 $SERVER_DIR/left4dead2_dlc3
COPY ./srcds_cache/left4dead2_lv $SERVER_DIR/left4dead2_lv

USER $USER

ENV APPID=$APPID
ENV APPNAME=$APPNAME
ENV SERVER_DIR=$SERVER_DIR
ENV PATH="$PATH:$SERVER_DIR"

EXPOSE 27015/udp

WORKDIR $SERVER_DIR
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["./srcds_run", "-game", "left4dead2"]
