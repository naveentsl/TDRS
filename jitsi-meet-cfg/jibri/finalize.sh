#!/bin/bash

DIR=$1
echo "Processing recording in directory: $DIR"

# Find the first MP4 file
MP4_FILE=$(find "$DIR" -maxdepth 1 -type f -name "*.mp4" | head -n 1)

if [[ -z "$MP4_FILE" ]]; then
    echo "Error: No MP4 file found in $DIR"
    exit 1
fi

# Extract filename from MP4 file
MP4_FILENAME=$(basename "$MP4_FILE")

# Extract meeting name and timestamp
MEETING_NAME=$(echo "$MP4_FILENAME" | awk -F'_' '{print $1}')
TIMESTAMP=$(echo "$MP4_FILENAME" | awk -F'_' '{print $2}' | sed 's/.mp4//')

# Define final destination directory
DEST_DIR="/config/recordings/${MEETING_NAME}"

# Ensure the meeting name folder exists
mkdir -p "$DEST_DIR"

# Move the MP4 file with timestamp to avoid overwrites
mv "$MP4_FILE" "${DEST_DIR}/${TIMESTAMP}.mp4"

if [[ $? -eq 0 ]]; then
    echo "Recording saved as ${DEST_DIR}/${TIMESTAMP}.mp4"
    rm -rf "$DIR"
else
    echo "Error: Failed to move the recording!"
    exit 1
fi

exit 0
