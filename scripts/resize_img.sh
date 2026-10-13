
#!/usr/bin/env bash

set -euo pipefail
shopt -s nullglob nocaseglob dotglob

# Usage: resize_img <image-or-directory> <width> <height>
if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <image-or-directory> <width> <height>"
    exit 1
fi

input=$1
width=$2
height=$3

# Validate dimensions
if [[ ! "$width" =~ ^[1-9][0-9]*$ ||
      ! "$height" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: width and height must be positive integers."
    exit 1
fi

# Detect ImageMagick
if command -v magick >/dev/null 2>&1; then
    identify_image() {
        magick identify "$1" >/dev/null 2>&1
    }

    resize_image() {
        magick "$1" \
            -auto-orient \
            -resize "${width}x${height}^" \
            -gravity center \
            -extent "${width}x${height}" \
            "$2"
    }
elif command -v convert >/dev/null 2>&1 &&
     command -v identify >/dev/null 2>&1; then
    identify_image() {
        identify "$1" >/dev/null 2>&1
    }

    resize_image() {
        convert "$1" \
            -auto-orient \
            -resize "${width}x${height}^" \
            -gravity center \
            -extent "${width}x${height}" \
            "$2"
    }
else
    echo "Error: ImageMagick is not installed."
    exit 1
fi

# Find input files
if [[ -d "$input" ]]; then
    output_dir="${input%/}/resized"
    [[ "$output_dir" == "/resized" ]] && output_dir="/resized"
    candidates=( "$input"/* )
elif [[ -f "$input" ]]; then
    output_dir="$(dirname -- "$input")/resized"
    candidates=( "$input" )
else
    echo "Error: '$input' does not exist or is not a file or directory."
    exit 1
fi

# Keep only supported images
images=()

for file in "${candidates[@]}"; do
    [[ -f "$file" ]] || continue

    if identify_image "$file"; then
        images+=( "$file" )
    fi
done

total=${#images[@]}

if (( total == 0 )); then
    echo "No supported images found."
    exit 1
fi

mkdir -p "$output_dir"

# Progress bar configuration
bar_width=30
completed=0
success_count=0
failures=()

show_progress() {
    local percent filled bar=""
    local i

    percent=$((completed * 100 / total))
    filled=$((completed * bar_width / total))

    for ((i = 0; i < bar_width; i++)); do
        if (( i < filled )); then
            bar+="#"
        else
            bar+="-"
        fi
    done

    printf '\r[%s] %3d%% (%d/%d)' \
        "$bar" "$percent" "$completed" "$total" >&2
}

printf 'Found %d image(s). Resizing to %sx%s...\n' \
    "$total" "$width" "$height" >&2

# Resize images and update progress
for file in "${images[@]}"; do
    filename="${file##*/}"

    # Preserve the original extension
    if [[ "$filename" == *.* && "$filename" != .* ]] ||
       [[ "$filename" == .*.* ]]; then
        name="${filename%.*}"
        extension=".${filename##*.}"
    else
        name="$filename"
        extension=""
    fi

    output="$output_dir/${name}-${width}x${height}${extension}"

    if resize_image "$file" "$output"; then
        success_count=$((success_count + 1))
    else
        failures+=( "$file" )
    fi

    completed=$((completed + 1))
    show_progress
done

printf '\n\n' >&2

# Final summary
printf 'Finished: %d/%d image(s) resized successfully.\n' \
    "$success_count" "$total"
printf 'Resolution: %sx%s\n' "$width" "$height"
printf 'Output directory: %s\n' "$output_dir"

if (( ${#failures[@]} > 0 )); then
    printf '\nFailed images:\n'
    for file in "${failures[@]}"; do
        printf '  %s\n' "$file"
    done
    exit 1
fi
