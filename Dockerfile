FROM debian:buster-slim
LABEL maintainer="me@jackz.me"

ENV USER csgo
ENV SERVER /home/$USER/hlserver
ENV STEAMACCOUNT ""
ENV RCON_PASS ""
ENV SV_PASS ""

RUN set -x \
    && apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install  --no-install-recommends --no-install-suggests lib32gcc1 curl net-tools lib32stdc++6 ca-certificates \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && useradd -m $USER  \
    && mkdir -p $SERVER

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

ADD ./csgo_ds.txt $SERVER/csgo_ds.txt
ADD ./autoexec.cfg $SERVER/csgo/csgo/cfg/autoexec.cfg
ADD ./server.cfg $SERVER/csgo/csgo/cfg/server.cfg
ADD ./csgo.sh $SERVER/csgo.sh

RUN chown -R $USER:$USER $SERVER && chmod +x $SERVER/*.sh

USER $USER
RUN curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $SERVER -xz  

EXPOSE 27015/udp
VOLUME $SERVER/csgo/csgo/addons $SERVER/csgo/csgo/addons $SERVER 

WORKDIR $SERVER
ENTRYPOINT ["./csgo.sh","+sv_steamaccount \"$STEAMACCOUNT\"","+sv_password \"$SV_PASS\"","+rcon_password \"$RCON_PASS\""]
CMD ["-console" "-usercon" "+game_type" "0" "+game_mode" "1" "+mapgroup" "mg_active" "+map" "de_cache"]
