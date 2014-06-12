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
TEMP_PATH=$HOME_PATH/share/temp
COMMON_PATH=$PROG_PATH/common

. $COMMON_PATH/base.sh
cd $PROG_PATH

OUT_DIR=$HOME_PATH/share/${channel}
OUT_FILE=$OUT_DIR/$FILENAME.mp3
FILE_OWNER=`$COMMON_PATH/getParam common owner`

mkdir -p $OUT_DIR $TEMP_PATH $PROG_PATH/log/
$PROG_PATH/radiko_download.sh $channel $time $flgPremium $TEMP_PATH/$FILENAME.flv $PROG_MODE
if [ $? -ne 0 ]; then
	exit 1;
fi

#
# ffmpeg 
#  *** root 権限でないとradikoユーザーだと書けない ***
# 
FFMPEG_LOG="$PROG_PATH/log/$channel_$output_$RECDATE.log"
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
echo "$MESSAGE"
exit $FFMPEG_STATUS

