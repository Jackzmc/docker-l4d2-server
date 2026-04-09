#!/bin/bash
APPID=222860
APPNAME=left4dead2
NAMESPACE=git.jackz.me/jackz
VERSION=$1
if [[ -z "$VERSION" ]]; then VERSION="base"; fi;

set -e

echo building content image
docker build -t $NAMESPACE/srcds-l4d2-content:latest -f content/Dockerfile .

echo building image
docker build -t $NAMESPACE/srcds-l4d2:latest -f $VERSION/Dockerfile "."