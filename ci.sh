#!/usr/bin/env bash

function makepkg() {
    pushd $1
    rm -f *.pkg.tar.xz
    rm -rf src pkg
    pacbrew-makepkg -c -f || exit 1
    sudo pacbrew-pacman --noconfirm -U ps5-payload-*.pkg.tar.xz || exit 1
    popd
}

sudo pacbrew-pacman --noconfirm --remove ps5-payload-dev

makepkg sdk
makepkg libcxx

makepkg bzip2
makepkg zlib
makepkg mbedtls
makepkg xz
makepkg libarchive
makepkg lua
makepkg tinyxml2
makepkg libsamplerate
makepkg SDL2

makepkg libpng
makepkg libjpeg-turbo
makepkg libwebp

makepkg freetype
makepkg libconfig
makepkg libsodium

makepkg SDL2_mixer
makepkg SDL2_ttf
makepkg SDL2_image

makepkg SDL2_net
makepkg curl

makepkg ffmpeg


