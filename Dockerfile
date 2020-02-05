FROM debian:buster-slim
LABEL maintainer="me@jackz.me"

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

COPY ./csgo_ds.txt $SERVER/csgo_ds.txt
COPY ./autoexec.cfg $SERVER/csgo/cfg/autoexec.cfg
COPY ./server.cfg $SERVER/csgo/cfg/server.cfg
COPY ./csgo.sh $SERVER/csgo.sh

RUN chown -R $USER:$USER $SERVER && chmod +x $SERVER/*.sh

USER $USER

RUN curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C /home/$USER -xz \
    && /home/$USER/steamcmd.sh +login anonymous +force_install_dir $SERVER +app_update 740 +quit \
    && mkdir -p /home/$USER/.steam/sdk32 /home/$USER/.steam/sdk64  \
    && cp /home/$USER/linux32/steamclient.so /home/$USER/.steam/sdk32/steamclient.so
COPY ./srcds_run $SERVER/srcds_run
# srcds cant find steamclient.so, copy it locally && srcds_run has incorrect autorestart executable (uses steam.sh instead of steamcmd.sh)

EXPOSE 27015/udp
VOLUME $SERVER/csgo/addons $SERVER/csgo/cfg $SERVER 

WORKDIR $SERVER
ENTRYPOINT ["./csgo.sh"]
CMD ["-console" "-usercon" "+game_type" "0" "+game_mode" "1" "+mapgroup" "mg_active" "+map" "de_cache"]
