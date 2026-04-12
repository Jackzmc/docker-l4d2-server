ARG DEBIAN_VERSION=bookworm
FROM debian:$DEBIAN_VERSION-slim AS installer

ARG APPID=222860
ARG USER=steam

# Install necessary libs
RUN apt-get update \
    && apt install -y lib32gcc-s1 curl

# Setup user
RUN addgroup --gid 1003 $USER && adduser --uid 1003 --gid 1003 $USER && mkdir /build && chown $USER /build
WORKDIR /build
USER $USER

# Download steamcmd installer
RUN mkdir steamcmd && curl -sqL "https://media.steampowered.com/client/steamcmd_linux.tar.gz" | tar xz -C steamcmd

# Init steamcmd
RUN steamcmd/steamcmd.sh +login anonymous +quit
# Install game via windows to get around freetodownload bug
RUN steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "$PWD"/srcds_cache \
    +login anonymous +app_update $APPID +quit
# Install game
RUN steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux +force_install_dir "$PWD"/srcds_cache \
    +login anonymous +app_update $APPID +quit

FROM scratch
COPY --from=installer /build/srcds_cache /game
COPY --from=installer /build/steamcmd    /steamcmd