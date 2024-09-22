#!/usr/bin/env bash

PKGS=(offact lakesnes fbneo eduke32 devilutionx mednafen lbreakouthd)

sudo pacman --noconfirm --remove ps5-payload-game

for PKG in ${PKGS[*]} ; do
    pushd $PKG || exit 1
    rm -f *.pkg.tar.gz
    rm -rf src pkg
    makepkg -c -f || exit 1
    sudo pacman --noconfirm -U ./ps5-payload-*.pkg.tar.gz || exit 1
    popd
done
