#!/bin/bash
# Trim a video based on a start/end time


# ANSI collor variables (BOLD)
NCollor='\033[0m'     # No Collor
BRed='\033[1;31m'     # Red
BGreen='\033[1;32m'   # Green
BYellow='\033[1;33m'  # Yellow

# Check if the correct number of arguments is supplied
if [ "$#" -ne 4 ]; then
  echo -e "${BRed} Error: Please provide video filename, start time, end time and output filename. ${NCollor}" >&2
  exit 1
fi

# Extract the arguments into variables
input_file="$1"
start_time="$2"
end_time="$3"
output_file="$4"

# Trim the video using FFmpeg
ffmpeg -i "$input_file" -ss "$start_time" -to "$end_time" -c copy "$output_file"

echo -e "${BGreen} Video trimmed and saved as $output_file successfully! ${NCollor}"
