ARG CONTENT_IMG=git.jackz.me/jackz/srcds-l4d2-content:latest
ARG DEBIAN_VERSION=bookworm

FROM $CONTENT_IMG AS content
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
    lib32stdc++6 \
    libstdc++6 \
    gcc-4.9 \
    binutils
    
# Cleanup
# RUN rm -rf /tmp/* /var/tmp/* && apk --purge del apk-tools
RUN apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add non-root user
RUN addgroup --gid 1003 $USER && adduser --uid 1003 --gid 1003 $USER

RUN mkdir -p $SERVER_DIR && mkdir -p ~/.steam/sdk32

# Potential fix for steamclient issues
COPY --chown=$USER --from=content \
    /steamcmd/sdk32/steamclient.so
    ~/.steam/sdk32/steamclient.so

# Copy external install to image
COPY --chown=$USER --from=content \
    /game/srcds_linux \
    /game/srcds_run \
    /game/left4dead2.dat \
    $SERVER_DIR/
COPY --chown=$USER --from=content /game/bin $SERVER_DIR/bin
COPY --chown=$USER --from=content /game/hl2 $SERVER_DIR/hl2
COPY --chown=$USER --from=content /game/platform $SERVER_DIR/platform
COPY --chown=$USER --from=content /game/update $SERVER_DIR/update
COPY --chown=$USER --from=content --exclude=media /game/left4dead2 $SERVER_DIR/left4dead2
COPY --chown=$USER --from=content /game/left4dead2_dlc1 $SERVER_DIR/left4dead2_dlc1
COPY --chown=$USER --from=content /game/left4dead2_dlc2 $SERVER_DIR/left4dead2_dlc2
COPY --chown=$USER --from=content /game/left4dead2_dlc3 $SERVER_DIR/left4dead2_dlc3
COPY --chown=$USER --from=content --exclude=media /game/left4dead2_lv $SERVER_DIR/left4dead2_lv

# Use our installed version of libstdc++6/libgcc instead of outdated bundled version:
RUN rm $SERVER_DIR/bin/libstdc++.so.6 \
    && rm $SERVER_DIR/bin/dedicated/libstdc++.so.6 \
    && rm $SERVER_DIR/bin/libgcc_s.so.1 \
    && rm $SERVER_DIR/bin/dedicated/libgcc_s.so.1

USER $USER

ENV APPID=$APPID
ENV APPNAME=$APPNAME
ENV SERVER_DIR=$SERVER_DIR
ENV PATH="$PATH:$SERVER_DIR"

EXPOSE 27015/udp

WORKDIR $SERVER_DIR
ENTRYPOINT ["./srcds_run", "-game", "left4dead2"]
