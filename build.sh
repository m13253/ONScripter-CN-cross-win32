#!/bin/bash

set -e
msg_info() {
    echo -e "\e[1;32m[I]\e[1;39m \e[1;30m$(date '+%Y-%m-%d %H:%M:%S')\e[1;39m $*\e[22m" >&2
}
msg_error() {
    echo -e "\e[1;31m[E]\e[1;39m \e[1;30m$(date '+%Y-%m-%d %H:%M:%S')\e[1;39m $*\e[22m" >&2
}
msg_warn() {
    echo -e "\e[1;33m[W]\e[1;39m \e[1;30m$(date '+%Y-%m-%d %H:%M:%S')\e[1;39m $*\e[22m" >&2
}
main() {

    startdir="$(pwd)"
    msg_info "Working directory is $startdir"

    msg_info 'Checking cross compile toolchain'
    [ -z "$HOSTARCH" ] && export HOSTARCH=i686-w64-mingw32
    [ -z "$CXX" ] && export CXX=g++
    if [ -z "$(which "$HOSTARCH-$CXX")" ]
    then
        msg_error "Cannot find cross compile toolchain for $HOSTARCH"
        exit 2
    fi

    msg_info 'Fetching source code'
    mkdir -p "$startdir/src"
    if [ -e "$startdir/src/ONScripter-CN" ]
    then
        msg_info 'git fetch ONScripter-CN'
        cd "$startdir/src/ONScripter-CN"
        git fetch --prune origin master || msg_warn 'Failed to update ONScripter-CN. You may be building an old version.'
        cd "$startdir"
    else
        msg_info 'git clone ONScripter-CN'
        git clone --mirror --branch master --depth 1 --single-branch https://github.com/m13253/ONScripter-CN.git "$startdir/src/ONScripter-CN"
    fi

    ver_SDL=1.2.15
    if [ ! -e "$startdir/src/SDL-${ver_SDL}.tar.gz" ]
    then
        msg_info "fetch SDL $ver_SDL"
        wget -O "$startdir/src/SDL-${ver_SDL}.tar.gz.part" https://www.libsdl.org/release/SDL-${ver_SDL}.tar.gz
        mv "$startdir/src/SDL-${ver_SDL}.tar.gz"{.part,}
    fi
    
    ver_SDL_image=1.2.12
    if [ ! -e "$startdir/src/SDL_image-${ver_SDL_image}.tar.gz" ]
    then
        msg_info "fetch SDL_image $ver_SDL_image"
        wget -O "$startdir/src/SDL_image-${ver_SDL_image}.tar.gz.part" https://www.libsdl.org/projects/SDL_image/release/SDL_image-${ver_SDL_image}.tar.gz
        mv "$startdir/src/SDL_image-${ver_SDL_image}.tar.gz"{.part,}
    fi

    ver_SDL_mixer=1.2.12
    if [ ! -e "$startdir/src/SDL_mixer-${ver_SDL_mixer}.tar.gz" ]
    then
        msg_info "fetch SDL_mixer $ver_SDL_mixer"
        wget -O "$startdir/src/SDL_mixer-${ver_SDL_mixer}.tar.gz.part" https://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-${ver_SDL_mixer}.tar.gz
        mv "$startdir/src/SDL_mixer-${ver_SDL_mixer}.tar.gz"{.part,}
    fi

    ver_SDL_ttf=2.0.11
    if [ ! -e "$startdir/src/SDL_ttf-${ver_SDL_ttf}.tar.gz" ]
    then
        msg_info "fetch SDL_ttf $ver_SDL_ttf"
        wget -O "$startdir/src/SDL_ttf-${ver_SDL_ttf}.tar.gz.part" https://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-${ver_SDL_ttf}.tar.gz
        mv "$startdir/src/SDL_ttf-${ver_SDL_ttf}.tar.gz"{.part,}
    fi

    ver_bzip2=1.0.6
    if [ ! -e "$startdir/src/bzip2-${ver_bzip2}.tar.gz" ]
    then
        msg_info "fetch bzip2 $ver_bzip2"
        wget -O "$startdir/src/bzip2-${ver_bzip2}.tar.gz.part" http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
        mv "$startdir/src/bzip2-${ver_bzip2}.tar.gz"{.part,}
    fi

    ver_smpeg=0_4_5
    if [ -e "$startdir/src/smpeg" ]
    then
        msg_info 'svn update smpeg'
        svn update "$startdir/src/smpeg" || msg_warn 'Failed to update smpeg. You may be building an old version.'
    else
        msg_info 'svn checkout smpeg'
        svn checkout svn://svn.icculus.org/smpeg/tags/release_$ver_smpeg "$startdir/src/smpeg"
    fi

    msg_info 'Extracting source code'
    rm -rf "$startdir/build"
    mkdir -p "$startdir/build"
    git clone "$startdir/src/ONScripter-CN" "$startdir/build/ONScripter-CN"
    tar xzf "$startdir/src/SDL-${ver_SDL}.tar.gz" -C "$startdir/build"
    tar xzf "$startdir/src/SDL_image-${ver_SDL_image}.tar.gz" -C "$startdir/build"
    tar xzf "$startdir/src/SDL_mixer-${ver_SDL_mixer}.tar.gz" -C "$startdir/build"
    tar xzf "$startdir/src/SDL_ttf-${ver_SDL_ttf}.tar.gz" -C "$startdir/build"
    tar xzf "$startdir/src/bzip2-${ver_bzip2}.tar.gz" -C "$startdir/build"
    cp -a "$startdir/src/smpeg" "$startdir/build/"

    msg_info 'Start building'

    msg_info 'Building ONScripter-CN'
    cd "$startdir/build/ONScripter-CN/jni/app_onscripter-32bpp/onscripter-20130317"
    cat >Makefile <<EOM
CFLAGS += -c -DWIN32 -DUSE_CDROM -DUSE_OGG_VORBIS -DUTF8_CAPTION
CFLAGS += -I$startdir/build/SDL-$ver_SDL/include
CFLAGS += -I$startdir/build/SDL_image-$ver_SDL_image
CFLAGS += -I$startdir/build/SDL_mixer-$ver_SDL_mixer
CFLAGS += -I$startdir/build/SDL_ttf-$ver_SDL_ttf
CFLAGS += -I$startdir/build/bzip2-$ver_bzip2
CFLAGS += -I$startdir/build/smpeg
OBJSUFFIX = .o
CC = $HOSTARCH-g++
LD = $HOSTARCH-g++ -o
TARGET = onscripter
include Makefile.onscripter
EOM
    make
    msg_info 'Successfully built'

}
main
