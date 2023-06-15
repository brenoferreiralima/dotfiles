#!/bin/bash

# Check if the correct number of arguments is supplied
if [ "$#" -ne 4 ]; then
  echo "Error: Please provide video filename, start time, end time and output filename." >&2
  exit 1
fi

# Extract the arguments into variables
input_file="$1"
start_time="$2"
end_time="$3"
output_file="$4"

# Trim the video using FFmpeg
ffmpeg -i "$input_file" -ss "$start_time" -to "$end_time" -c copy "$output_file"

echo "Video trimmed and saved as $output_file successfully!"