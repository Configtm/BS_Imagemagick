#!/bin/bash
set -x
set -e
set -o pipefail

REPORT_FILE="/app/test_report.txt"

MAGICK_BIN="/opt/zoho/ImageMagick-7.1.1-47/bin/magick"

{
    echo "ImageMagick Packaging Test Report"
    echo "Generated on: $(date)"
    echo "--------------------------------------"
    $MAGICK_BIN --version
    echo ""

    echo "Testing image conversion..."
    $MAGICK_BIN -size 100x100 xc:red /tmp/red.png
    $MAGICK_BIN  /tmp/red.png /tmp/red.jpg

    if [[ -f /tmp/red.jpg ]]; then
        echo " Image conversion test passed"
    else
        echo " Image conversion test failed"
        exit 1
    fi

    echo ""
    echo "Testing image resize..."
    $MAGICK_BIN /tmp/red.png -resize 50x50 /tmp/red_resized.png

    if [[ -f /tmp/red_resized.png ]]; then
        echo " Resize test passed"
    else
        echo " Resize test failed"
        exit 1
    fi

    echo ""
    echo "Testing text overlay..."
    $MAGICK_BIN -size 200x60 xc:lightblue -pointsize 20 -gravity center \
        -draw "text 0,0 'Hello from ImageMagick'" /tmp/text_overlay.png

    if [[ -f /tmp/text_overlay.png ]]; then
        echo " Text overlay test passed"
    else
        echo " Text overlay test failed"
        exit 1
    fi

} &> "$REPORT_FILE"

echo "Test report written to $REPORT_FILE"
cp "$REPORT_FILE" /opt/test_report.txt  # Host-mount accessible
