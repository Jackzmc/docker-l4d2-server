FROM jackzmc/srcds-l4d2:base

ARG APPNAME=left4dead2

ARG METAMOD_URL=https://mms.alliedmods.net/mmsdrop/2.0/mmsource-2.0.0-git1314-linux.tar.gz
ARG SOURCEMOD_URL=https://sm.alliedmods.net/smdrop/1.12/sourcemod-1.12.0-git7167-linux.tar.gz

ENV USER=steam
ENV SERVER=/server

# Metamod
RUN curl $METAMOD_URL | tar -C $SERVER/$APPNAME/ -xz
# Sourcemod
RUN curl $SOURCEMOD_URL | tar -C $SERVER/$APPNAME/ -xz 

EXPOSE 27015/udp

WORKDIR $SERVER
ENTRYPOINT ["/bin/bash", "-c"]
CMD [""]
