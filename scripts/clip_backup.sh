#!/bin/bash

# Check if the correct number of arguments is supplied
if [ "$#" -ne 1 ]; then
  echo "Error: Please provide video filename." >&2
  exit 1
fi

# Extract the arguments into variables
input_file="$1"

# Trim the video using FFmpeg
ffmpeg -i "$input_file" -crf 18 -preset veryslow -c:a copy "bkp_$input_file"

echo "Video converted and saved as bkp_$input_file successfully!"
