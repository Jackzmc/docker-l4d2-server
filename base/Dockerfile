FROM debian:12

ARG APPID=222860
ARG APPNAME=left4dead2
ARG USER=steam
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
# Setup dirs / user
RUN useradd -m $USER \
    && mkdir -p $SERVER_DIR \
    && chown -R $USER:$USER $SERVER_DIR

USER $USER

#RUN curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C /home/$USER -xz \
#    && /home/$USER/steamcmd.sh +quit \
#    && mkdir -p /home/$USER/.steam/sdk32 /home/$USER/.steam/sdk64
# Download
#RUN /home/$USER/steamcmd.sh +force_install_dir $SERVER_DIR +login anonymous +app_update $APPID validate +quit
ADD srcds_cache $SERVER_DIR
# Copy the steamclient from steamcmd because there's some weirdness
RUN cp /home/$USER/linux32/steamclient.so /home/$USER/.steam/sdk32/steamclient.so
RUN chmod +x $SERVER_DIR/*.sh

ENV LD_LIBRARY_PATH .:bin:$LD_LIBRARY_PATH
ENV APPID $APPID
ENV APPNAME $APPNAME
ENV SERVER_DIR $SERVER_DIR
ENV PATH $PATH:$SERVER_DIR

EXPOSE 27015/udp

WORKDIR $SERVER_DIR
ENTRYPOINT ["/bin/bash", "-c"]
CMD [""]
