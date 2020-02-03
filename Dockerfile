FROM debian:buster-slim
LABEL maintainer="me@jackz.me"

ENV USER steam
ENV SERVER /home/$USER/server
ENV STEAMACCOUNT ""
ENV RCON_PASS ""
ENV SV_PASS ""
# server will contain root dir (aka for csgo, ~/server/csgo/addons)

RUN set -x \
    && apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install  --no-install-recommends --no-install-suggests lib32gcc1 curl net-tools lib32stdc++6 ca-certificates \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && useradd -m $USER  \
    && mkdir -p $SERVER

ADD ./csgo_ds.txt $SERVER/csgo_ds.txt
ADD ./autoexec.cfg $SERVER/csgo/cfg/autoexec.cfg
ADD ./server.cfg $SERVER/csgo/cfg/server.cfg
ADD ./csgo.sh $SERVER/csgo.sh

RUN chown -R $USER:$USER $SERVER && chmod +x $SERVER/*.sh

USER $USER
RUN curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C "/home/$USER" -xz \
    && $SERVER/steamcmd.sh +login anonymous +force_install_dir $SERVER +app_update 740 validate +quit

EXPOSE 27015/udp
VOLUME $SERVER/csgo/addons $SERVER/csgo/cfg $SERVER 

WORKDIR $SERVER
ENTRYPOINT ["./csgo.sh","+sv_steamaccount \"$STEAMACCOUNT\"","+sv_password \"$SV_PASS\"","+rcon_password \"$RCON_PASS\""]
CMD ["-console" "-usercon" "+game_type" "0" "+game_mode" "1" "+mapgroup" "mg_active" "+map" "de_cache"]
