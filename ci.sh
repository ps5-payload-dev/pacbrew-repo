#!/usr/bin/env bash

PKGS=(sdk libcxx
      bzip2 zlib xz zstd libarchive
      mbedtls
      libiconv libfribidi
      libconfig json-c tinyxml2
      #libmagic
      libmicrohttpd
      libpng libjpeg-turbo libwebp
      freetype harfbuzz
      libsamplerate libsodium libogg flac libass
      SDL2 SDL2_mixer SDL2_ttf SDL2_image SDL2_net SDL2_gfx
      lua curl ffmpeg SDL2_kitchensink)

sudo pacman --noconfirm --remove ps5-payload-dev

for PKG in ${PKGS[*]} ; do
    pushd $PKG || exit 1
    rm -f *.pkg.tar.gz
    rm -rf src pkg
    makepkg -c -f || exit 1
    sudo pacman --noconfirm -U ./ps5-payload-*.pkg.tar.gz || exit 1
    popd
done
