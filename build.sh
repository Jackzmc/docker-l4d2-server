#!/bin/bash
APPID=222860
APPNAME=left4dead2

if [[ ! -d "steamcmd" ]]; then
    echo "No steamcmd detected, setting up steamcmd..."
    mkdir steamcmd
    curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C steamcmd -xz
fi
steamcmd/steamcmd.sh +force_install_dir ./srcds_cache +login anonymous +app_update $APPID validate +quit
# docker build -t srcds-l4d2:base base
# docker build -t srcds-l4d2:sourcemod sourcemod
