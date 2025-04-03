#!/bin/bash
set -x #debug mode
set -e #exit the script when there is an error
set -o pipefail

PACKAGE=ImageMagick
VERSION=$PACKAGE-7.1.1-47
URL=https://imagemagick.org/archive/$VERSION.tar.gz
TAR=$VERSION.tar.gz
DEST=/opt/zoho/$VERSION
OUTPUT=/home/patcher/$VERSION.tar.gz

###create Destination directory ######
mkdir -p $DEST

export http_proxy=http://192.168.100.100:3128
export https_proxy=http://192.168.100.100:3128


##Download SOURCE TAR ################
wget -O $OUTPUT $URL || { echo "Download failed! Exiting."; exit 1; } 

unset http_proxy https_proxy

##### install dependencies ##########
sudo apt install -y \
  build-essential pkg-config autoconf automake \
  libjpeg-dev libpng-dev libtiff-dev libwebp-dev libheif-dev libopenjp2-7-dev libraw-dev \
  libxml2-dev libfreetype6-dev libfontconfig1-dev \
  libbz2-dev liblzma-dev libltdl-dev libfftw3-dev libopenexr-dev \
  ghostscript gsfonts libperl-dev libglib2.0-dev
  
  ###### EXTRACT the source ############

cd /home/patcher

tar -xzvf $TAR

cd $VERSION


######## compatabilty check and setup stage ###########

## ImageMagick does NOT support dynamically installing modules after compilation.  
## If needed additional modules, you must enable them during the `./configure` stage.  
## Modify the flags below to include the required modules before compiling.

./configure --prefix=$DEST \
            --enable-shared \
            --enable-hdri \
            --enable-openmp \
            --with-modules \
            --with-jpeg \
            --with-png \
            --with-tiff \
            --with-webp \
            --with-heic \
            --with-openjp2 \
            --with-raw \
            --with-xml \
            --with-fontconfig \
            --with-freetype \
            --with-lzma \
            --with-bzlib \
            --with-ltdl \
            --with-fftw \
            --with-openexr \
            --with-perl \
            --without-x \
            --disable-dependency-tracking


#########compilation  and building stage,############## 
##if you no need over push of cpu core then remove nproc #

make -j$(( $(nproc) / 2 )) 2>&1 | tee build.log
sudo make install
if make check  
then
	if $DEST/bin/magick --version >/dev/null 2>&1 
	then
		echo "IMAGEMAGICK INSTALLED SUCCESSFULLY"

	else
		echo "IMAGEMAGICK NOT INSTALLED PROPERLY"
	
	fi
else
	echo " make Test failed "
fi

############ tar the binary package ##############

tar -czvf $VERSION.tar.gz -C $DEST . 

echo " compilation is completed output tar saved --> $OUTPUT "



