#!/bin/bash
APPID=222860
APPNAME=left4dead2
NAMESPACE=jackzmc
VERSION=$1
if [[ -z "$VERSION" ]]; then VERSION="base"; fi;
echo "Building $NAMESPACE/srcds-l4d2:$VERSION for $APPID ($APPNAME)"
if [[ ! -d "steamcmd" ]]; then
    echo "No steamcmd detected, setting up steamcmd..."
    mkdir steamcmd
    curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C steamcmd -xz

    # Changes in freetodownload cause "Invalid Platform" on linux, need to download windows version and then verify on linux:
    echo "Running first time freetodownload fix +app_update $APPID $EXTRA_ARGS"
    steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir "$PWD"/srcds_cache +login anonymous +app_update $APPID +quit
fi

EXTRA_ARGS="$2"

echo "Running +app_update $APPID $EXTRA_ARGS"
steamcmd/steamcmd.sh +@sSteamCmdForcePlatformType linux   +force_install_dir "$PWD"/srcds_cache +login anonymous +app_update $APPID +quit

# If steamcmd fails, srcds_cache will still have 'steamapps' folder instead of the completed download
if [ ! -d "$PWD/srcds_cache/left4dead2" ]; then
    echo Game download is invalid
    exit 2
fi

# cp steamcmd/linux32/steamclient.so "$PWD"/srcds_cache/bin
echo Building $VERSION...
docker build -t $NAMESPACE/srcds-l4d2:$VERSION -f $VERSION/Dockerfile "."
