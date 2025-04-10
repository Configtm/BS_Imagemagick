#!/bin/bash

set -x
set -e
set -o pipefail


##########cleanup previous build

#rm -rf ImageMagick-7.1.1*
#rm -rf /opt/zoho/ImageMagick-7.1.1*

#####install dependicies

apt update && apt install -y curl libssl-dev libffi-dev \
  libjpeg-dev libpng-dev libtiff-dev libwebp-dev libheif-dev libopenjp2-7-dev libraw-dev \
  libxml2-dev libfreetype6-dev libfontconfig1-dev \
  libbz2-dev liblzma-dev libltdl-dev libfftw3-dev libopenexr-dev \
  ghostscript gsfonts libperl-dev libglib2.0-dev

#######create executing binaries directory

mkdir -p /opt/zoho/ImageMagick-7.1.1-47

# Check if env vars are passed
if [[ -z "$JFROG_USER" || -z "$JFROG_APIKEY" ]]; then
  echo "Missing JFROG_USER or JFROG_APIKEY. Exiting."
  exit 1
fi

# Download from JFrog securely
curl -u"$JFROG_USER:$JFROG_APIKEY" -L -O "http://10.62.21.97:8081/artifactory/docker-docker-local/ImageMagick-binaries/ImageMagick-7.1.1-47.tar.gz"

tar -xzvf ImageMagick-7.1.1-47.tar.gz -C /opt/zoho/ImageMagick-7.1.1-47/


