#!/bin/sh
cd $HOME/hlserver
~/hlserver/steamcmd.sh +login anonymous +force_install_dir ./csgo +app_update 740 validate +quit&&
csgo/srcds_run -game csgo -tickrate 128 -autoupdate -steam_dir ~/hlserver -steamcmd_script ~/hlserver/csgo_ds.txt $@
