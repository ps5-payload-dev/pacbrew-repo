#!/usr/bin/env bash

SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"

PKGS=(sdk openlibm libcxx openmp fast_float fmt
      bzip2 zlib libminizip xz zstd libarchive libdeflate
      openssl libssh
      libevent libiconv libfribidi libpsl
      libconfig json-c tinyxml2 libxml2 expat jansson
      miniupnpc
      file libb64 libnatpmp libutp
      sqlite libmicrohttpd libmicrodns
      libnfs libsmb2 libssh2
      libpng libjpeg-turbo libwebp giflib
      freetype harfbuzz fontconfig
      libsamplerate libsodium libogg libvorbis flac opus
      mpg123 lame libmad faad2 libmodplug libsndfile
      libass
      libvpx libmpeg2 libtheora
      enet glm
      dht
      SDL2 SDL2_mixer SDL2_ttf SDL2_image SDL2_net SDL2_gfx
      lua luajit libquickjs
      imgui rmlui curl ffmpeg SDL2_kitchensink
      llvm mesa
      openal love
      shsrv # for prospero-shsrv-shell
      websrv # for prospero-websrv-elfldr
     )

sudo pacman --noconfirm --remove ps5-payload-dev

for PKG in ${PKGS[*]} ; do
    pushd $PKG || exit 1
    rm -f *.pkg.tar.gz
    rm -rf src pkg
    makepkg -c -f -C || exit 1
    sudo pacman \
	 --config "${SCRIPT_DIR}/pacman.conf" \
	 --noconfirm -U ./ps5-payload-*.pkg.tar.gz || exit 1
    popd
done
