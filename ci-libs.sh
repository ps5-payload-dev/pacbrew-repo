#!/usr/bin/env bash

PKGS=(sdk openlibm libcxx fast_float
      bzip2 zlib xz zstd libarchive libdeflate
      mbedtls bearssl wolfssl
      libevent libiconv libfribidi
      libconfig json-c tinyxml2 expat jansson
      miniupnpc
      file
      sqlite libmicrohttpd
      libpng libjpeg-turbo libwebp giflib
      freetype harfbuzz fontconfig
      libsamplerate libsodium libogg libvorbis flac opus
      mpg123 lame libmad a52dec faad2 libsndfile
      libass
      libvpx libmpeg2 libtheora
      enet osmesa glm
      SDL2 SDL2_mixer SDL2_ttf SDL2_image SDL2_net SDL2_gfx
      imgui lua curl ffmpeg SDL2_kitchensink
     )

sudo pacman --noconfirm --remove ps5-payload-dev

for PKG in ${PKGS[*]} ; do
    pushd $PKG || exit 1
    rm -f *.pkg.tar.gz
    rm -rf src pkg
    makepkg -c -f || exit 1
    sudo pacman --noconfirm -U ./ps5-payload-*.pkg.tar.gz || exit 1
    popd
done
