#!/bin/bash
# Re-encode a video file on a smaller size to share on discord


# ANSI collor variables (BOLD)
NCollor='\033[0m'     # No Collor
BRed='\033[1;31m'     # Red
BGreen='\033[1;32m'   # Green
BYellow='\033[1;33m'  # Yellow

# Check if the correct number of arguments is supplied
if [ "$#" -ne 1 ]; then
  echo -e "${BRed} Error: Please provide video filename. ${NCollor}" >&2
  exit 1
fi

# Extract the arguments into variables
input_file="$1"

# Trim the video using FFmpeg
ffmpeg -i "$input_file" -crf 28 -preset slow -c:a copy "discord_$input_file"

echo -e "${BGreen} Video encoded and saved as discord_$input_file successfully! ${NCollor}"
