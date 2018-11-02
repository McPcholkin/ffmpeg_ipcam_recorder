#!/bin/bash

# Start record sound from webcam

FFMPEG=`which ffmpeg`
AUDIO_DEV=$1
DEST_VID_FILE=$2
VIDEO_EXT=${DEST_VID_FILE##*.}
FILE_NAME=${DEST_VID_FILE%.$VIDEO_EXT}
AUDIO_EXT='wav'
DEST_AUDIO_FILE="$FILE_NAME.$AUDIO_EXT"
CAM_ID=$3
FFMPEG_PID_FILE_BASE='/tmp/ffmpeg_pid_'
FFMPEG_PID_FILE="$FFMPEG_PID_FILE_BASE$3"

CONTROL_PID_FILE_BASE='/tmp/ffmpeg_control_pid_'
CONTROL_PID_FILE="$CONTROL_PID_FILE_BASE$3"

CLIP_LEN='10m'
AUDIO_CHAN='1'
AUDIO_RATE='44100'
DEBUG='true'

if [ $# != 3 ]  # check if any argument exist
   then         # show help
        echo "No arguments"
        echo
        echo "Usage: audio_device dest_video_file cam_id"
        echo "Example:"
        echo "       $0 'default:CARD=U0x46d0x8b5' /srv/motion/cam1/capture.avi orb_cam"
        echo
        exit 1
fi

if [ $DEBUG == 'true' ]
  then
    echo "----------------------------"
    echo "        Debug enabled"
    echo "----------------------------"
    echo ""
    echo "ffmpeg path - $FFMPEG"
    echo "Audio device - $AUDIO_DEV"
    echo "Destenation video_file - $DEST_VID_FILE"
    echo "Video file ext - $VIDEO_EXT"
    echo "Destenation audio_file - $DEST_AUDIO_FILE"
    echo "Cameta ID - $CAM_ID"
    echo ""
fi

if [ $DEBUG == 'true' ]
  then
    echo "Start record"
    echo ""
    LOGLEVEL='info'
    #LOGLEVEL='quiet'
  else
    LOGLEVEL='quiet'
fi
 
function ffmpeg_run { 
  $FFMPEG -loglevel $LOGLEVEL -f alsa -ac $AUDIO_CHAN -ar $AUDIO_RATE -i $AUDIO_DEV $DEST_AUDIO_FILE & FFMPEG_PID=$!
}


ffmpeg_run

echo $FFMPEG_PID > $FFMPEG_PID_FILE
echo $BASHPID > $CONTROL_PID_FILE

if [ $DEBUG == 'true' ]
  then
    echo "FFMPEG PID - $FFMPEG_PID"
    echo "CONTROL PID - $BASHPID"

    echo "FFMPEG PID file - $FFMPEG_PID_FILE"
    echo "Control PID file - $CONTROL_PID_FILE"
    echo ""
fi   

# Wait for record clip max lenght
sleep $CLIP_LEN
# stop ffmpeg
kill $FFMPEG_PID
rm $FFMPEG_PID_FILE
rm $CONTROL_PID_FILE
    
if [ $DEBUG == 'true' ]
  then
    echo "ffmpeg killed PID - $FFMPEG_PID  after - $CLIP_LEN"
    echo ""
fi



