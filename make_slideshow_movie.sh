#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

SLIDESHOW_FILE="latest.mp4"

FIRST_RUN=1


while [[ 1 ]]; do

    echo "$(date): Checking..."

    # rename the scripts based on creation time

    i=1
    UPDATED=0

    for file in $(ls -U photobooth-photos/*.JPG); do
        NEW_FILE="photobooth-photos/`printf %04d $i`.JPG"

        if [[ "$file" != "$NEW_FILE" ]]; then
            echo "$(date): Moving $file to $NEW_FILE"
            mv "$file" "$NEW_FILE"
            UPDATED=1
        fi

        i=$(($i+1))
    done

    # make the slideshow

    if [[ $FIRST_RUN -eq 1 || $UPDATED -eq 1 ]]; then
        echo "$(date): Generating $SLIDESHOW_FILE"
        ffmpeg -y -r 8 -i photobooth-photos/%04d.JPG -s 1920x1280 photobooth-slideshow-movie/$SLIDESHOW_FILE
    fi

    FIRST_RUN=0

    # wait a bit

    sleep 5

done