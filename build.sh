#!/bin/bash
APPID=222860
APPNAME=left4dead2
NAMESPACE=jackzmc
if [[ ! -d "steamcmd" ]]; then
    echo "No steamcmd detected, setting up steamcmd..."
    mkdir steamcmd
    curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C steamcmd -xz
fi

steamcmd/steamcmd.sh +force_install_dir $PWD/srcds_cache +login anonymous +app_update $APPID validate +quit
cp steamcmd/linux32/steamclient.so $PWD/srcds_cache/bin
echo Building base...
docker build -t $NAMESPACE/srcds-l4d2:base -f base/Dockerfile "."
echo Building sourcemod...
docker build -t $NAMESPACE/srcds-l4d2:sourcemod -f sourcemod/Dockerfile "."
