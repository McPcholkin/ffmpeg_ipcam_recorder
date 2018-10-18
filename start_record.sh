#!/bin/bash

# Start record from h264 ipcam



FFMPEG=`which ffmpeg`
STREAM=$1
DEST_DIR=$2
FFMPEG_PID_FILE_BASE='/tmp/ffmpeg_pid_'
FFMPEG_PID_FILE="$FFMPEG_PID_FILE_BASE$3"
CLIP_LEN='10m'
AUDIO_CODEC='copy'
VIDEO_CODEC='copy'
DEBUG='true'

if [ $# != 3 ]  # check if any argument exist
   then         # show help
        echo "No arguments"
        echo
        echo "Usage: camera_stream dest_dir cam_id"
        echo "Example:"
        echo "       $0 rtsp://username:password@192.168.1.2/live /srv/ipcamrecord/ dahua123"
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
    echo "IPCam stream - $STREAM"
    echo "Destenation dir - $DEST_DIR"
    echo "Cameta ID - $3"
    echo ""
fi

function make_cam_dir {
  mkdir -p $DEST_DIR$(date +%Y)/$(date +%m)/$(date +%d)/
}

if [ $DEBUG == 'true' ]
  then
    echo "Start record"
    echo ""
    #LOGLEVEL='info'
    LOGLEVEL='quiet'
  else
    LOGLEVEL='quiet'
fi
 
function ffmpeg_run { 
  $FFMPEG -loglevel $LOGLEVEL -i $STREAM -acodec $AUDIO_CODEC -vcodec $VIDEO_CODEC $DEST_DIR$(date +%Y)/$(date +%m)/$(date +%d)/$(date +%Y-%m-%d_%H-%M-%S).avi & FFMPEG_PID=$!
}

# init pid file
touch $FFMPEG_PID_FILE

# Clip rotation
while true
  do
    if [ -e $FFMPEG_PID_FILE ]
      then
        make_cam_dir

        if [ $DEBUG == 'true' ]
          then
            echo "Create dir - $DEST_DIR$(date +%Y)/$(date +%m)/$(date +%d)/"
            echo ""
        fi

        ffmpeg_run
 
        if [ $DEBUG == 'true' ]
          then
            echo "FFMPEG PID - $FFMPEG_PID"
            echo "PID file - $FFMPEG_PID_FILE"
            echo ""
        fi   

        # Wait for record clip
        sleep $CLIP_LEN
        # stop ffmpeg
        kill $FFMPEG_PID
    
        if [ $DEBUG == 'true' ]
          then
            echo "ffmpeg killed PID - $FFMPEG_PID  after - $CLIP_LEN"
            echo ""
        fi
      else
        # kill ffmpeg if file not exist
        kill $FFMPEG_PID
        
        if [ $DEBUG == 'true' ]
          then
            echo "No pid file found - stop recording"
            echo "Kill PID - $FFMPEG_PID"
        fi
  
        exit 0
    fi
  done


