#!/usr/bin/env bash

set -uo pipefail

# Batch image resizer for Linux using ImageMagick.
# Supports HD, Full HD, 2K, 4K and custom aspect ratios.

PRESET="fullhd"
OUTPUT="resized"
RATIO="16:9"
QUALITY=100

usage() {
    cat <<'EOF'
Usage:
  ./img_batch_resize [options] FILES_OR_DIRECTORIES...

Options:
  -r, --resolution PRESET  hd | fullhd | 2k | 4k
  -o, --output DIR         Output directory (default: resized)
  -a, --aspect RATIO       Aspect ratio, e.g. 16:9, 4:3, 1:1
  -q, --quality NUMBER     Output quality 1-100 (default: 100)
  -h, --help               Show this help

Examples:
  ./img_batch_resize -r hd *.jpg
  ./img_batch_resize -r 4k -o output photos/
  ./img_batch_resize -r 2k -a 4:3 *.png
  ./img_batch_resize -r fullhd -a 1:1 photos/

Images are center-cropped to the selected aspect ratio.
Supported formats: JPG, JPEG, PNG, WEBP, TIFF, BMP, GIF, AVIF.
EOF
}

while (($#)); do
    case "$1" in
        -r|--resolution)
            [[ $# -ge 2 ]] || { echo "Missing resolution"; exit 1; }
            PRESET="${2,,}"; shift 2 ;;
        -o|--output)
            [[ $# -ge 2 ]] || { echo "Missing output directory"; exit 1; }
            OUTPUT="$2"; shift 2 ;;
        -a|--aspect)
            [[ $# -ge 2 ]] || { echo "Missing aspect ratio"; exit 1; }
            RATIO="$2"; shift 2 ;;
        -q|--quality)
            [[ $# -ge 2 ]] || { echo "Missing quality"; exit 1; }
            QUALITY="$2"; shift 2 ;;
        -h|--help)
            usage; exit 0 ;;
        --)
            shift
            break ;;
        -*)
            echo "Unknown option: $1"
            usage
            exit 1 ;;
        *)
            break ;;
    esac
done

INPUTS=("$@")

if ((${#INPUTS[@]} == 0)); then
    echo "Error: provide at least one image or directory."
    usage
    exit 1
fi

case "$PRESET" in
    hd)    WIDTH=1280 ;;
    fullhd) WIDTH=1920 ;;
    2k)    WIDTH=2560 ;;
    4k)    WIDTH=3840 ;;
    *)
        echo "Error: resolution must be hd, fullhd, 2k, or 4k."
        exit 1 ;;
esac

if ! [[ "$QUALITY" =~ ^[0-9]+$ ]] ||
   ((QUALITY < 1 || QUALITY > 100)); then
    echo "Error: quality must be between 1 and 100."
    exit 1
fi

if ! [[ "$RATIO" =~ ^[0-9]+:[0-9]+$ ]]; then
    echo "Error: aspect ratio must look like 16:9 or 4:3."
    exit 1
fi

RATIO_W="${RATIO%%:*}"
RATIO_H="${RATIO##*:}"

if ((RATIO_W == 0 || RATIO_H == 0)); then
    echo "Error: aspect ratio values must be greater than zero."
    exit 1
fi

# Calculate height from the selected width and aspect ratio.
HEIGHT=$((WIDTH * RATIO_H / RATIO_W))

if ((HEIGHT < 1)); then
    echo "Error: calculated image height is invalid."
    exit 1
fi

# Support both ImageMagick 7 (magick) and ImageMagick 6 (convert).
if command -v magick >/dev/null 2>&1; then
    IM=(magick)
elif command -v convert >/dev/null 2>&1; then
    IM=(convert)
else
    echo "Error: ImageMagick is not installed."
    echo "Install it with: sudo apt install imagemagick"
    exit 1
fi

mkdir -p -- "$OUTPUT" || exit 1

# Collect supported image files. Directory inputs are searched recursively.
FILES=()
while IFS= read -r -d '' file; do
    FILES+=("$file")
done < <(
    find "${INPUTS[@]}" \
        -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' \
           -o -iname '*.png' -o -iname '*.webp' \
           -o -iname '*.tif' -o -iname '*.tiff' \
           -o -iname '*.bmp' -o -iname '*.gif' \
           -o -iname '*.avif' \) \
        -print0 2>/dev/null
)

# Remove files inside the output directory to avoid reprocessing outputs.
OUTPUT_ABS="$(realpath -m -- "$OUTPUT")"
FILTERED=()

for file in "${FILES[@]}"; do
    FILE_ABS="$(realpath -m -- "$file")"
    if [[ "$FILE_ABS" == "$OUTPUT_ABS"/* ||
          "$FILE_ABS" == "$OUTPUT_ABS" ]]; then
        continue
    fi
    FILTERED+=("$file")
done
FILES=("${FILTERED[@]}")

TOTAL=${#FILES[@]}

if ((TOTAL == 0)); then
    echo "No supported images found."
    exit 1
fi

# Show a terminal progress bar.
progress() {
    local current=$1 total=$2 name=$3
    local percent=$((current * 100 / total))
    local filled=$((percent / 2))
    local bar=""
    printf -v bar '%*s' "$filled" ''
    bar="${bar// /#}"
    printf '\r[%-50s] %3d%% (%d/%d) %s\033[K' \
        "$bar" "$percent" "$current" "$total" "$name"
}

echo "Resolution : ${PRESET} (${WIDTH}x${HEIGHT})"
echo "Aspect ratio: ${RATIO}"
echo "Output      : ${OUTPUT}"
echo "Images found: ${TOTAL}"
echo

SUCCESS=0
FAILED=0
INDEX=0

for file in "${FILES[@]}"; do
    ((INDEX += 1))

    # Preserve the original filename and extension.
    name="$(basename -- "$file")"
    destination="$OUTPUT/$name"

    progress "$INDEX" "$TOTAL" "$name"

    # Resize to fill the target dimensions, then center-crop to exact size.
    # The ^ modifier fills both dimensions without stretching the image.
    if "${IM[@]}" "$file" \
        -auto-orient \
        -resize "${WIDTH}x${HEIGHT}^" \
        -gravity center \
        -extent "${WIDTH}x${HEIGHT}" \
        -strip \
        -quality "$QUALITY" \
        "$destination" 2>/dev/null; then
        ((SUCCESS += 1))
    else
        ((FAILED += 1))
        rm -f -- "$destination"
    fi
done

echo
echo
echo "========================================"
echo "Batch resizing complete!"
echo "Total images : $TOTAL"
echo "Successful   : $SUCCESS"
echo "Failed       : $FAILED"
echo "Output folder: $OUTPUT"
echo "Dimensions   : ${WIDTH}x${HEIGHT}"
echo "========================================"
