#/bin/sh


if [ $# -eq 2 ]; then
	channel=$1
	time=$2

elif [ $# -eq 3 ]; then
	channel=$1
	time=$2
	flgPremium=$3

else
	echo "usage : $0 channel_name buffer_time premium_mode<free,premium>"
	exit 1
fi

HOME_PATH=/home/ubuntu/radiko-man
PROG_PATH=$HOME_PATH
COMMON_PATH=$PROG_PATH/common

. $COMMON_PATH/base.sh
cd $PROG_PATH

AUTHOR="radiko.jp"
STATION_NAME=`$COMMON_PATH/getRadioStation $channel`

#
# rtmpdump
#
$PROG_PATH/radiko_download.sh $channel live $flgPremium live-$REC_DATE | vlc --meta-title " " --meta-author $AUTHOR --meta-artist $STATION_NAME --meta-date $REC_DATE --play-and-exit --no-one-instance - 2> /dev/null
exit 0

