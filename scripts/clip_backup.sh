#!/bin/bash
# Re-encode a video file on a smaller size for backup


# ANSI Color variables (BOLD)
NColor='\033[0m'      # No Color
BRed='\033[1;31m'     # Red
BGreen='\033[1;32m'   # Green
BYellow='\033[1;33m'  # Yellow

# Check if the correct number of arguments is supplied
if [ "$#" -ne 1 ]; then
  echo -e "${BRed} Error: Please provide video filename. ${NColor}" >&2
  exit 1
fi

# Extract the arguments into variables
input_file="$1"

# Trim the video using FFmpeg
ffmpeg -i "$input_file" -crf 18 -preset veryslow -c:a copy "bkp_$input_file"

echo -e "${BGreen} Video encoded and saved as bkp_$input_file successfully! ${NColor}"
