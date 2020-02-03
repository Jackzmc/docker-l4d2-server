#!/bin/sh
cd $HOME/hlserver
~/hlserver/steamcmd.sh +runscript ~/hlserver/csgo_ds.txt &&
csgo/srcds_run -game csgo -tickrate 128 -autoupdate -steam_dir ~/hlserver -steamcmd_script ~/hlserver/csgo_ds.txt $@
