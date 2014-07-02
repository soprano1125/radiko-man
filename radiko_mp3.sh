#/bin/sh


if [ $# -eq 3 ]; then
	channel=$1
	time=$2
	flgPremium=$3
	output=$1

elif [ $# -eq 4 ]; then
	channel=$1
	time=$2
	flgPremium=$3
	output=$4

else
	echo "usage : $0 channel_name rec_time premium_mode<free,premium> [outputfile]"
	exit 1
fi

HOME_PATH=/home/ubuntu/radiko-man
PROG_PATH=$HOME_PATH
COMMON_PATH=$HOME_PATH/common
RADIKO_COMMON=$PROG_PATH/common

TEMP_PATH=$HOME_PATH/share/temp

. $COMMON_PATH/base.sh
cd $PROG_PATH

OUT_DIR=$HOME_PATH/share/$channel
OUT_FILE=$OUT_DIR/$FILENAME.mp3
FILE_OWNER=`$COMMON_PATH/getParam common owner`

mkdir -p $TEMP_PATH $PROG_PATH/log/ $OUT_DIR
$PROG_PATH/radiko_download.sh $channel $time $flgPremium $TEMP_PATH/$FILENAME.flv
if [ $? -ne 0 ]; then
	exit 1;
fi

#
# ffmpeg 
# 
FFMPEG_LOG="$PROG_PATH/log/$channel_$FILENAME.log"
echo $OUT_FILE >> $FFMPEG_LOG
sudo ffmpeg -y -i $TEMP_PATH/$FILENAME.flv -ab 128k -ar 44100 -ac 2 $OUT_FILE 2>> $FFMPEG_LOG
FFMPEG_STATUS=$?

#
# remove
#
if [ $FFMPEG_STATUS -ne 0 ]
then
	# エンコードミスした時の保険
	MESSAGE="$FILENAME.mp3:$channel convert miss"
else
	sudo chown -R $FILE_OWNER $OUT_DIR
	rm -rf $TEMP_PATH/$FILENAME.flv
	MESSAGE="$FILENAME.mp3:$channel convert done"
fi

#$HOME_PATH/twitter/post.sh "$MESSAGE" > /dev/null
echo "$MESSAGE" 1>&2
exit $FFMPEG_STATUS

