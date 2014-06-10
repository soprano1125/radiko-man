#!/bin/bash


if [ "$RECDATE" == "" ]; then
	RECDATE=`date +"%Y%m%d%H%M"`
fi
FILENAME=$output"_"$RECDATE

TTY=`tty`
if [ "$TTY" == "not a tty" ]; then
	DISP_MODE="/dev/null"
else
	DISP_MODE=$TTY
fi

