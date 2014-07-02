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

. common/base.sh
cd $PROG_PATH

OUT_DIR=$HOME_PATH/share/$channel
OUT_FILE=$OUT_DIR/$FILENAME.flv
FILE_OWNER=`$COMMON_PATH/getParam common owner`

mkdir -p $TEMP_PATH $PROG_PATH/log/ $OUT_DIR
$PROG_PATH/radiko_download.sh $channel $time $flgPremium $TEMP_PATH/$FILENAME.flv
if [ $? -ne 0 ]; then
	exit 1;
fi

sudo mv $TEMP_PATH/$FILENAME.flv $OUT_FILE
sudo chown -R $FILE_OWNER $OUT_DIR

exit 0

