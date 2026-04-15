ARG CONTENT_IMG=git.jackz.me/jackz/srcds-l4d2-content:latest
ARG DEBIAN_VERSION=bookworm

FROM $CONTENT_IMG AS content
FROM debian:$DEBIAN_VERSION-slim

ARG APPID=222860
ARG APPNAME=left4dead2
ARG SERVER_DIR=/server
ARG USER=steam
ARG UID=1003
ARG GID=$UID

# Add non-root user
RUN addgroup --gid $GID $USER && adduser --uid $UID --gid $GID $USER

# Copy content image files to this image
COPY --chown=$USER --from=content \
    /game/hlds_steamgames.vdf \
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

# Install runtime dependencies
# Some dependencies (gcc, libcurl4, file, etc) are not strictly necessary, just provided to aid in testing
RUN set -x \
    && dpkg --add-architecture i386 \
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
    binutils \
    libcurl4 \
    file

# Cleanup APT and remove apt sources
RUN apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
# Use our installed version of libstdc++6/libgcc instead of outdated bundled version:
# This fixes issues with System2 ext not working with outdated versions
RUN rm $SERVER_DIR/bin/libstdc++.so.6 \
    && rm $SERVER_DIR/bin/dedicated/libstdc++.so.6 \
    && rm $SERVER_DIR/bin/libgcc_s.so.1 \
    && rm $SERVER_DIR/bin/dedicated/libgcc_s.so.1
    
RUN mkdir -p $SERVER_DIR && mkdir -p /home/$USER/.steam/sdk32

# Fix for steamclient issues
# We copy to ~/.steam/sdk32 where the game looks for it there instead of it's own local version
COPY --chown=$USER --from=content \
    /steamcmd/linux32/steamclient.so \
    /home/$USER/.steam/sdk32/steamclient.so

# If necessary to deal with permissions, make everything readable.
# NOTE: TAKES VERY LONG TIME. 5 minutes on my machine, 2h+ before cancelled on CI
# RUN chown -R $USER:$USER /home/$USER && chmod -R 777 $SERVER_DIR /home/$USER
    
USER $USER

ENV APPID=$APPID
ENV APPNAME=$APPNAME
ENV SERVER_DIR=$SERVER_DIR
ENV PATH="$PATH:$SERVER_DIR"

EXPOSE 27015/udp

WORKDIR $SERVER_DIR

# Provides default command flags such as -nowatchdog (fixes "Alarm Clock" crash)
COPY --chown=$USER docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

# Bash is used to ensure CTRL+C and stdin still work
ENTRYPOINT ["/bin/bash", "./docker-entrypoint.sh"]
CMD []

