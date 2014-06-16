#/bin/sh


if [ $# -eq 4 ]; then
	channel=$1
	time=$2
	flgPremium=$3
	DUMP_FILE=$4

else
	echo "usage : $0 channel_name rec_time premium_mode<free,premium> outputfile"
	exit 1
fi

HOME_PATH=/home/ubuntu/radiko-man
PROG_PATH=$HOME_PATH
TEMP_PATH=$HOME_PATH/share/temp
COMMON_PATH=$PROG_PATH/common

. $COMMON_PATH/base.sh
cd $PROG_PATH

PROG_MODE=`$COMMON_PATH/getParam common prog_mode`
MODULE_PATH=$PROG_PATH/$PROG_MODE

APP_VERSION=`$COMMON_PATH/getParam common player_ver`
playerurl="http://radiko.jp/player/swf/player_$APP_VERSION.swf"
AUTH_KEY=`$COMMON_PATH/getParam premium auth_key`
COOKIE_FILE=`$COMMON_PATH/getParam premium cookie_file`
AREA_FILE=`$COMMON_PATH/getParam common area_file`

FILE_NAME=`echo $DUMP_FILE | sed -e "s|$TEMP_PATH\/||g"`

isPremium="FreeMode"
isPremiumRet=1
if [ "$flgPremium" = "premium" ]; then
	$MODULE_PATH/login
	isPremiumRet=$?
	isPremium="PremiumMode"
fi

MESSAGE=`$MODULE_PATH/makeKey $APP_VERSION`
if [ $? -ne 0 ]; then
	if [ $isPremiumRet -ne 1 ]; then $MODULE_PATH/logout; fi
	MESSAGE="$FILE_NAME:$channel rec miss[$MESSAGE][$isPremium]"
#	$HOME_PATH/twitter/post.sh "$MESSAGE" > /dev/null
	echo $MESSAGE
	rm -rf $AUTH_KEY $COOKIE_FILE $AREA_FILE
	exit 1;
fi
echo $MESSAGE

MESSAGE=`$MODULE_PATH/checkArea $channel $isPremiumRet`
if [ $? -ne 0 ]; then
	if [ $isPremiumRet -ne 1 ]; then $MODULE_PATH/logout; fi
	MESSAGE=`echo $MESSAGE | cut -d '|' -f 2` 
	MESSAGE="$FILE_NAME:$channel rec miss[$MESSAGE][$isPremium]"
#	$HOME_PATH/twitter/post.sh "$MESSAGE" > /dev/null
	echo $MESSAGE
	rm -rf $AUTH_KEY $COOKIE_FILE $AREA_FILE
	exit 1;
fi
echo $MESSAGE

if [ $isPremiumRet -ne 1 ]; then
	$MODULE_PATH/logout
fi

IFS=','

TEXT=`cat $AUTH_KEY`
set -- $TEXT
authtoken=$1
echo $authtoken
rm -rf $AUTH_KEY $COOKIE_FILE $AREA_FILE

TEXT=`$COMMON_PATH/getStreamParam ${channel}`
set -- $TEXT
SERVER=$1
APPLICATION=$2
PLAYPATH=$3

##########################################################
# rtmpdump
##########################################################
MESSAGE="$FILE_NAME:$channel rec do"
echo $MESSAGE
#$HOME_PATH/twitter/post.sh "$MESSAGE" > /dev/null
rtmpdump -v -r "$SERVER" --playpath "$PLAYPATH" --app "$APPLICATION" -W $playerurl -C S:"" -C S:"" -C S:"" -C S:$authtoken --stop $time --timeout 3600 --live --flv $DUMP_FILE 2> $DISP_MODE
RTMPDUMP_STATUS=$?

if [ $RTMPDUMP_STATUS -ne 0 ]; then
	MESSAGE="$FILE_NAME:$channel rec miss"
else
	MESSAGE="$FILE_NAME:$channel rec done"
fi

#$HOME_PATH/twitter/post.sh "$MESSAGE" > /dev/null
echo $MESSAGE
exit $RTMPDUMP_STATUS

