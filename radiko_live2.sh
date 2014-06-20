#/bin/sh


if [ $# -eq 1 ]; then
	channel=$1
	flgPremium="free"

elif [ $# -eq 2 ]; then
	channel=$1
	flgPremium=$2

else
	echo "usage : $0 channel_name [premium_mode<free,premium>]"
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
$PROG_PATH/radiko_download.sh $channel live $flgPremium live-$REC_DATE | cvlc --meta-title " " --meta-author $AUTHOR --meta-artist $STATION_NAME --meta-date $REC_DATE --play-and-exit --no-one-instance --no-sout-display-video -I dummy - 2> /dev/null 

exit 0

