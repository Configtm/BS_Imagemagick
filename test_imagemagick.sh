#!/bin/bash
set -e
set -o pipefail

REPORT_FILE="/app/test_report.txt"

{
    echo "ImageMagick Packaging Test Report"
    echo "Generated on: $(date)"
    echo "--------------------------------------"
    /opt/zoho/ImageMagick-7.1.1-47/bin/magick --version
    echo ""
    echo "Testing image conversion..."

    convert -size 100x100 xc:red /tmp/red.png
    convert /tmp/red.png /tmp/red.jpg

    if [[ -f /tmp/red.jpg ]]; then
        echo "Image conversion test passed"
    else
        echo "Image conversion test failed"
        exit 1
    fi
} &> "$REPORT_FILE"

echo "Test report written to $REPORT_FILE"
cp "$REPORT_FILE" /opt/test_report.txt  # Host-mount accessible
