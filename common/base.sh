#!/bin/bash

#########################################################
HOME_PATH=/home/ubuntu/radiko-man
PROG_PATH=$HOME_PATH
COMMON_PATH=$HOME_PATH/common
RADIKO_COMMON=$PROG_PATH/common

TEMP_PATH=$HOME_PATH/share/temp
#########################################################

if [ "$REC_DATE" == "" ]; then
	REC_DATE=`date +"%Y%m%d%H%M"`
fi
FILENAME=$output"_"$REC_DATE

USER_AGENT="`$COMMON_PATH/makeUserAgent radiko.jp \`$COMMON_PATH/getParam common player_ver\``"
HTTP_TIMEOUT="`$COMMON_PATH/getParam common http_timeout`"

TTY=`tty`
if [ "$TTY" == "not a tty" ]; then
	DISP_MODE="/dev/null"
else
	DISP_MODE=$TTY
fi

