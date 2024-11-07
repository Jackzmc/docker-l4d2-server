FROM debian:12

ARG APPID=222860
ARG APPNAME=left4dead2

ENV USER=steam
ENV SERVER=/server

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
# Setup dirs / user
RUN useradd -m $USER \
    && mkdir -p $SERVER \
    && chown -R $USER:$USER $SERVER

USER $USER

RUN curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C /home/$USER -xz \
    && /home/$USER/steamcmd.sh +quit \
    && mkdir -p /home/$USER/.steam/sdk32 /home/$USER/.steam/sdk64
# Download
RUN /home/$USER/steamcmd.sh +force_install_dir $SERVER +login anonymous +app_update $APPID validate +quit
#COPY ./srcds-cache $SERVER
# Copy the steamclient from steamcmd because there's some weirdness
RUN cp /home/$USER/linux32/steamclient.so /home/$USER/.steam/sdk32/steamclient.so
RUN chmod +x $SERVER/*.sh

EXPOSE 27015/udp

WORKDIR $SERVER
ENTRYPOINT ["/bin/bash", "-c"]
CMD [""]
