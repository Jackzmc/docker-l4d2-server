FROM debian:buster-slim
LABEL maintainer="me@jackz.me"

ARG APPNAME=left4dead2

ENV USER steam
ENV SERVER /home/$USER/server
# $SERVER will contain root dir (aka for csgo, ~/server/csgo/addons)
# steamcmd stored in /home/$USER

RUN set -x \
    && apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install  --no-install-recommends --no-install-suggests lib32gcc1 curl net-tools lib32stdc++6 ca-certificates \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && useradd -m $USER  \
    && mkdir -p $SERVER

COPY ./autoexec.cfg $SERVER/$APPNAME/cfg/autoexec.cfg
COPY ./server.cfg $SERVER/$APPNAME/cfg/server.cfg
COPY ./entry.sh $SERVER/entry.sh

RUN chown -R $USER:$USER $SERVER && chmod +x $SERVER/*.sh

USER $USER

RUN curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C /home/$USER -xz \
    && /home/$USER/steamcmd.sh +quit \
    && mkdir -p /home/$USER/.steam/sdk32 /home/$USER/.steam/sdk64

COPY ./srcds-cache $SERVER
RUN cp /home/$USER/linux32/steamclient.so /home/$USER/.steam/sdk32/steamclient.so
COPY ./srcds_run $SERVER/srcds_run
# srcds cant find steamclient.so, copy it locally && srcds_run has incorrect autorestart executable (uses steam.sh instead of steamcmd.sh)

EXPOSE 27015/udp
VOLUME $SERVER/$APPNAME/addons $SERVER/$APPNAME/cfg $SERVER 

WORKDIR $SERVER
ENTRYPOINT ["./entry.sh"]
CMD ["-console" "-usercon"]
