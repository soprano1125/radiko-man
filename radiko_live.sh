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

PROG_MODE=`$COMMON_PATH/getParam common prog_mode`
MODULE_PATH=$PROG_PATH/$PROG_MODE

SERVER=`$COMMON_PATH/getParam common server`
PLAYPATH=`$COMMON_PATH/getParam common play_path`
APPLICATION="${channel}/`$COMMON_PATH/getParam common application`"
APP_VERSION=`$COMMON_PATH/getParam common player_ver`
playerurl="http://radiko.jp/player/swf/player_$APP_VERSION.swf"
AUTH_KEY=`$COMMON_PATH/getParam premium auth_key`
COOKIE_FILE=`$COMMON_PATH/getParam premium cookie_file`
AREA_FILE=`$COMMON_PATH/getParam common area_file`

isPremium=1
if [ "$flgPremium" = "premium" ]; then
	$MODULE_PATH/login
	isPremium=$?
fi

$MODULE_PATH/makeKey $APP_VERSION
if [ $? -ne 0 ]; then
	if [ $isPremium -ne 1 ]; then $MODULE_PATH/logout; fi
	rm -rf $AUTH_KEY $COOKIE_FILE $AREA_FILE
	exit 1;
fi

$MODULE_PATH/checkArea $channel $isPremium
if [ $? -ne 0 ]; then
	if [ $isPremium -ne 1 ]; then $MODULE_PATH/logout; fi
	rm -rf $AUTH_KEY $COOKIE_FILE $AREA_FILE
	exit 1;
fi

if [ $isPremium -ne 1 ];
then
	$MODULE_PATH/logout
else
	sleep 1
fi

TEXT=`cat $AUTH_KEY`; IFS=','
set -- $TEXT
authtoken=$1
echo $authtoken
rm -rf $AUTH_KEY $COOKIE_FILE $AREA_FILE

#
# rtmpdump
#
rtmpdump -v -r "$SERVER" --playpath "$PLAYPATH" --app "$APPLICATION" -W $playerurl -C S:"" -C S:"" -C S:"" -C S:"$authtoken" --timeout $time --live --flv - 2> /dev/null | vlc - 2> /dev/null
exit 0

