#!/bin/bash

# End record from h264 ipcam

FFMPEG_PID_FILE_BASE='/tmp/ffmpeg_pid_'
FFMPEG_PID_FILE="$FFMPEG_PID_FILE_BASE$1"
FFMPEG_PID=$(cat $FFMPEG_PID_FILE)

CONTROL_PID_FILE_BASE='/tmp/ffmpeg_control_pid_'
CONTROL_PID_FILE="$CONTROL_PID_FILE_BASE$1"
CONTROL_PID=$(cat $CONTROL_PID_FILE)

DEBUG='true'

if [ $# != 1 ]  # check if any argument exist
   then         # show help
        echo "No arguments"
        echo
        echo "Usage: cam_id"
        echo "Example:"
        echo "       $0 dahua123"
        echo
        exit 1
fi

if [ $DEBUG == 'true' ]
  then
    echo "----------------------------"
    echo "        Debug enabled"
    echo "----------------------------"
    echo ""
    echo "Cameta ID - $1"
    echo ""
fi

kill $FFMPEG_PID
kill $CONTROL_PID

rm $FFMPEG_PID_FILE
rm $CONTROL_PID_FILE

if [ $DEBUG == 'true' ]
  then
   echo "ffmpeg killed PID - $FFMPEG_PID"
   echo "Control killed PID - $CONTROL_PID"
   echo "file removed - $FFMPEG_PID_FILE"
   echo "file removed - $CONTROL_PID_FILE"
   echo ""
fi
 
