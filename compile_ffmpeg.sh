#!/bin/bash -x

mkdir ~/ffmpeg_sources
#sudo apt-get update && sudo apt-get upgrade

# Bash script to install latest version of ffmpeg and its dependencies on Ubuntu 16.04
# Inspired from https://gist.github.com/faleev/3435377

# Remove any existing packages:
sudo apt -y remove ffmpeg x264 libav-tools libvpx-dev libx264-dev

# Get the dependencies (Ubuntu Server or headless users):
sudo apt update
sudo apt -y install autoconf automake build-essential libass-dev libfreetype6-dev \
  git libsdl2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo wget zlib1g-dev

sudo apt-get -y install build-essential checkinstall git libfaac-dev libgpac-dev \
  libjack-jackd2-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev \
  librtmp-dev libsdl1.2-dev libtheora-dev libva-dev libvdpau-dev libvorbis-dev \
  libx11-dev libxfixes-dev pkg-config texi2html yasm zlib1g-dev

# Install Yasm:
sudo apt -y install yasm
# An assembler for x86 optimizations used by x264 and FFmpeg. Highly recommended or your resulting build may be very slow.

# Otherwise you can compile:
#cd ~/ffmpeg_sources
#wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
#tar xzvf yasm-1.3.0.tar.gz
#cd yasm-1.3.0
#./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
#make
#make install

# Install nasm:
# NASM assembler. Required for compilation of x264 and other tools.
cd ~/ffmpeg_sources
wget http://www.nasm.us/pub/nasm/releasebuilds/2.13.01/nasm-2.13.01.tar.bz2
tar xjvf nasm-2.13.01.tar.bz2
cd nasm-2.13.01
./autogen.sh
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
PATH="$HOME/bin:$PATH" make
make install

# Install libx264:
sudo apt -y install libx264-dev

# Otherwise you can compile:
#cd ~/ffmpeg_sources
#wget http://download.videolan.org/pub/x264/snapshots/last_x264.tar.bz2
#tar xjvf last_x264.tar.bz2
#cd x264-snapshot*
#PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-#static --disable-opencl
#PATH="$HOME/bin:$PATH" make
#make install
#sudo checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | \
#  awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
#    --fstrans=no --default

# Install libx265-dev:
sudo apt-get -y install libx265-dev
# Otherwise you can compile:

#sudo apt-get -y install cmake mercurial
#cd ~/ffmpeg_sources
#hg clone https://bitbucket.org/multicoreware/x265
#cd ~/ffmpeg_sources/x265/build/linux
#PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -#DENABLE_SHARED:bool=off ../../source
#make
#make install


# Install libfdk-aac AAC audio decoder
sudo apt -y install libfdk-aac-dev
# Otherwise you can compile:
#cd ~/ffmpeg_sources
#wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
#tar xzvf fdk-aac.tar.gz
#cd mstorsjo-fdk-aac*
#autoreconf -fiv
#./configure --prefix="$HOME/ffmpeg_build" --disable-shared
#make
#make install

# Install libmp3lame MP3 audio encoder .
sudo apt -y install libmp3lame-dev
# Otherwise you can compile:
#cd ~/ffmpeg_sources
#wget http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
#tar xzvf lame-3.99.5.tar.gz
#cd lame-3.99.5
#./configure --prefix="$HOME/ffmpeg_build" --enable-nasm --disable-shared
#make
#make install

# Install libopus opus audio decoder and encoder.
sudo apt -y install libopus-dev
# Otherwise you can compile:
#cd ~/ffmpeg_sources
#wget https://archive.mozilla.org/pub/opus/opus-1.1.5.tar.gz
#tar xzvf opus-1.1.5.tar.gz
#cd opus-1.1.5
#./configure --prefix="$HOME/ffmpeg_build" --disable-shared
#make
#make install

# Install libvpx VP8/VP9 video encoder and decoder.
sudo apt -y install libvpx-dev
# Otherwise you can compile:
#cd ~/ffmpeg_sources
#git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
#cd libvpx
#PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-#unit-tests
#PATH="$HOME/bin:$PATH" make
#make install


# Add lavf support to x264
# This allows x264 to accept just about any input that FFmpeg can handle and is useful if you want to use x264 directly. See a more detailed explanation of what this means.

#cd ~/x264
#make distclean
#./configure --enable-static
#make
#sudo checkinstall --pkgname=x264 --pkgversion="3:$(./version.sh | \
#  awk -F'[" ]' '/POINT/{print $4"+git"$5}')" --backup=no --deldoc=yes \
#  --fstrans=no --defaultls

# compile the FFmpeg NVIDIA headers ("ffnvcodec"):
# https://superuser.com/questions/1299064/error-cuvid-requested-but-not-all-dependencies-are-satisfied-cuda/1303317
cd ~/ffmpeg_sources
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers
make
sudo make install

# Installing FFmpeg
cd ~/ffmpeg_sources
git clone --depth 1 https://github.com/FFmpeg/FFmpeg ffmpeg
cd ffmpeg
#PATH="/opt/ffmpeg/bin:$PATH"
#PKG_CONFIG_PATH="/opt/ffmpeg/lib/pkgconfig"
./configure \
  --prefix="/opt/ffmpeg" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-cflags=-I/usr/local/cuda/include \
  --extra-ldflags=-L/usr/local/cuda/lib64 \
  --bindir="/opt/ffmpeg/bin" \
  --enable-shared \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopencore-amrnb \
  --enable-libopencore-amrwb \
  --enable-librtmp \
  --enable-libopus \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree \
  --enable-version3 \
  --enable-libtheora \
  --enable-libwebp \
  --enable-opengl \
  --cpu=native \
  --enable-nvenc \
  --enable-vaapi \
  --enable-vdpau  \
  --enable-openssl \
  --enable-cuda \
  --enable-cuvid \
  --enable-libnpp

#  --enable-libopencv \
#  --enable-libopenjpeg \

#  --enable-libfaac \
#  --enable-libschroedinger \
#  --enable-netcdf \
#  --enable-ladspa \
#  --enable-libbluray \
#  --enable-libgsm \
#  --enable-libsmbclient \
#  --enable-libsoxr \
#  --enable-libssh \
#  --enable-libspeex \
#  --enable-libwavpack \
#  --enable-libxvid \
#  --enable-openal  \
#  --enable-opencl \
#  --enable-x11grab \ # not available for ubuntu server

#PATH="/opt/ffmpeg/bin:$PATH"
make -j
make install
hash -r
sudo checkinstall --pkgname=ffmpeg --pkgversion="5:$(date +%Y%m%d%H%M)-git" --backup=no \
  --deldoc=yes --fstrans=no --default
# hash x264 ffmpeg ffplay ffprobe  # do not know what this command mean

# Optional: install qt-faststart
# This is a useful tool if you're showing your H.264 in MP4 videos on the web. It relocates some data in the video to allow playback to begin before the file is completely downloaded. Usage: qt-faststart input.mp4 output.mp4.
#cd ~/ffmpeg
#make tools/qt-faststart
#sudo checkinstall --pkgname=qt-faststart --pkgversion="$(date +%Y%m%d%H%M)-git" --backup=no \
#  --deldoc=yes --fstrans=no --default install -Dm755 tools/qt-faststart \
#  /usr/local/bin/qt-faststart


