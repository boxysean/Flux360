#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

SLIDESHOW_FILE="latest.mp4"


while [[ 1 ]]; do

    # rename the scripts based on creation time

    i=1
    UPDATED=0

    for file in $(ls -U photobooth-photos/*.JPG); do
        NEW_FILE=photobooth-photos/`printf %04d $i`.JPG

        if [[ "$file" -ne "$NEW_FILE" ]]; then
            echo "$(date): Moving $file to $NEW_FILE"
            mv "$file" "$NEW_FILE"
            i=$(($i+1))
            UPDATED=1
        fi
    done

    # make the slideshow

    if [[ $UPDATED -eq 1 ]]; then
        echo "$(date): Generating $SLIDESHOW_FILE"
        ffmpeg -r 8 -i %04d.JPG -s 1920x1280 photobooth-slideshow-movie/$SLIDESHOW_FILE
    fi

    # wait a bit

    sleep 5

done