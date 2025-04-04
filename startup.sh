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

curl -uadmin:cmVmdGtuOjAxOjE3NzUwNjE4ODA6M0hHcXJ6bGdxM01rc2tzaUZYOU1OSzdVam0z -L -O "http://10.65.150.52:8082/artifactory/demo/ImageMagick-binaries/ImageMagick-7.1.1-47.tar.gz"

tar -xzvf ImageMagick-7.1.1-47.tar.gz -C /opt/zoho/ImageMagick-7.1.1-47/

/opt/zoho/ImageMagick-7.1.1-47/bin/magick --version | grep Delegates


if ldd /opt/zoho/ImageMagick-7.1.1-47/bin/magick | grep "not found"
    then
        echo "ImageMagick dependencies missing"
	exit 1
    else
        echo "ImageMagick module & dependencies installed successfully"
fi
