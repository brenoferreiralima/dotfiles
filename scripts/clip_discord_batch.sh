#!/bin/bash
# Get all mp4 files in a dir and re-encode them on a smaller size to share on discord

# ANSI collor variables (BOLD)
NCollor='\033[0m'     # No Collor
BRed='\033[1;31m'     # Red
BGreen='\033[1;32m'   # Green
BYellow='\033[1;33m'  # Yellow

# Extract the arguments into variables
for input_file in *.mp4 
do

  # Encode the video using FFmpeg
  ffmpeg -i "$input_file" -crf 28 -preset slow -c:a copy "discord_$input_file"
  echo -e "${BYellow} Video encoded and saved as discord_$input_file successfully! ${NCollor}"

done

echo -e "${BGreen} All videos encoded successfully! ${NCollor}"
