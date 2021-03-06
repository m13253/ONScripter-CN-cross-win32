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
build_envcheck() {
    startdir="$(pwd)"
    if echo -n "$startdir" | grep -q ' '
    then
        msg_error 'Your working directory contains space'
        exit 1
    fi
    msg_info "Working directory is $startdir"

    msg_info 'Checking cross compile toolchain'
    [ -z "$HOSTARCH" ] && export HOSTARCH=i686-w64-mingw32
    [ -z "$CXX" ] && export CXX="$HOSTARCH-g++"
    if [ -z "$(which "$CXX")" ]
    then
        msg_error "Cannot find cross compile toolchain for $HOSTARCH"
        exit 2
    fi

    ver_SDL=1.2.15
    ver_SDL_image=1.2.12
    ver_SDL_mixer=1.2.12
    ver_SDL_ttf=2.0.11
    ver_libiconv=1.14
    ver_bzip2=1.0.6
    ver_zlib=1.2.8
    ver_libpng=1.6.12
    ver_libjpeg_turbo=1.3.1
    ver_libtiff=4.0.3
    ver_giflib=5.1.0
    ver_libmikmod=3.3.7
    ver_libogg=1.3.2
    ver_libvorbis=1.3.4
    ver_flac=1.3.0
    ver_smpeg=0_4_5
    ver_harfbuzz=0.9.35
    ver_freetype=2.5.3
    ver_lua=5.1.5

    build_envcheck_ok=1
}
build_fetch() {
    [ "$build_envcheck_ok" != "1" ] && build_envcheck
    cd "$startdir"
    msg_info 'Fetching source code'
    mkdir -p "$startdir/src"

    if [ -e "$startdir/src/ONScripter-CN" ]
    then
        if [ "$BUILD_NO_UPDATE" == "1" ]
        then
            msg_warn 'Not updating ONScripter-CN since $BUILD_NO_UPDATE=1'
        else
            msg_info 'git fetch ONScripter-CN'
            cd "$startdir/src/ONScripter-CN"
            git fetch --prune --progress origin master || msg_warn 'Failed to update ONScripter-CN. You may be building an old version.'
        fi
    else
        msg_info 'git clone ONScripter-CN'
        git clone --mirror --branch master --depth 1 --single-branch --progress https://github.com/m13253/ONScripter-CN.git "$startdir/src/ONScripter-CN"
    fi

    if [ ! -e "$startdir/src/SDL-${ver_SDL}.tar.gz" ]
    then
        msg_info "fetch SDL $ver_SDL"
        wget -c -O "$startdir/src/SDL-${ver_SDL}.tar.gz.part" https://www.libsdl.org/release/SDL-${ver_SDL}.tar.gz
        mv "$startdir/src/SDL-${ver_SDL}.tar.gz"{.part,}
    fi
    
    if [ ! -e "$startdir/src/SDL_image-${ver_SDL_image}.tar.gz" ]
    then
        msg_info "fetch SDL_image $ver_SDL_image"
        wget -c -O "$startdir/src/SDL_image-${ver_SDL_image}.tar.gz.part" https://www.libsdl.org/projects/SDL_image/release/SDL_image-${ver_SDL_image}.tar.gz
        mv "$startdir/src/SDL_image-${ver_SDL_image}.tar.gz"{.part,}
    fi

    if [ ! -e "$startdir/src/SDL_mixer-${ver_SDL_mixer}.tar.gz" ]
    then
        msg_info "fetch SDL_mixer $ver_SDL_mixer"
        wget -c -O "$startdir/src/SDL_mixer-${ver_SDL_mixer}.tar.gz.part" https://www.libsdl.org/projects/SDL_mixer/release/SDL_mixer-${ver_SDL_mixer}.tar.gz
        mv "$startdir/src/SDL_mixer-${ver_SDL_mixer}.tar.gz"{.part,}
    fi

    if [ ! -e "$startdir/src/SDL_ttf-${ver_SDL_ttf}.tar.gz" ]
    then
        msg_info "fetch SDL_ttf $ver_SDL_ttf"
        wget -c -O "$startdir/src/SDL_ttf-${ver_SDL_ttf}.tar.gz.part" https://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-${ver_SDL_ttf}.tar.gz
        mv "$startdir/src/SDL_ttf-${ver_SDL_ttf}.tar.gz"{.part,}
    fi

    if [ ! -e "$startdir/src/libiconv-${ver_libiconv}.tar.gz" ]
    then
        msg_info "fetch libiconv $ver_libiconv"
        wget -c -O "$startdir/src/libiconv-${ver_libiconv}.tar.gz.part" https://ftp.gnu.org/pub/gnu/libiconv/libiconv-${ver_libiconv}.tar.gz
        mv "$startdir/src/libiconv-${ver_libiconv}.tar.gz"{.part,}
    fi

    if [ ! -e "$startdir/src/bzip2-${ver_bzip2}.tar.gz" ]
    then
        msg_info "fetch bzip2 $ver_bzip2"
        wget -c -O "$startdir/src/bzip2-${ver_bzip2}.tar.gz.part" http://www.bzip.org/1.0.6/bzip2-${ver_bzip2}.tar.gz
        mv "$startdir/src/bzip2-${ver_bzip2}.tar.gz"{.part,}
    fi

    if [ ! -e "$startdir/src/zlib-${ver_zlib}.tar.gz" ]
    then
        msg_info "fetch zilb $ver_zlib"
        wget -c -O "$startdir/src/zlib-${ver_zlib}.tar.gz.part" http://zlib.net/zlib-${ver_zlib}.tar.gz
        mv "$startdir/src/zlib-${ver_zlib}.tar.gz"{.part,}
    fi

    if [ ! -e "$startdir/src/libpng-${ver_libpng}.tar.xz" ]
    then
        msg_info "fetch libpng $ver_libpng"
        wget -c -O "$startdir/src/libpng-${ver_libpng}.tar.xz.part" http://download.sourceforge.net/libpng/libpng-${ver_libpng}.tar.xz
        mv "$startdir/src/libpng-${ver_libpng}.tar.xz"{.part,}
    fi
    if [ ! -e "$startdir/src/libpng-$ver_libpng-apng.patch.gz" ]
    then
        msg_info "fetch libpng-apng.patch"
        wget -c -O "$startdir/src/libpng-$ver_libpng-apng.patch.gz.part" http://downloads.sourceforge.net/sourceforge/libpng-apng/libpng-$ver_libpng-apng.patch.gz
        mv "$startdir/src/libpng-$ver_libpng-apng.patch.gz"{.part,}
    fi

    if [ ! -e "$startdir/src/libjpeg-turbo-${ver_libjpeg_turbo}.tar.gz" ]
    then
        msg_info "fetch libjpeg-turbo $ver_libjpeg_turbo"
        wget -c -O "$startdir/src/libjpeg-turbo-${ver_libjpeg_turbo}.tar.gz.part" http://downloads.sourceforge.net/project/libjpeg-turbo/$ver_libjpeg_turbo/libjpeg-turbo-${ver_libjpeg_turbo}.tar.gz
        mv "$startdir/src/libjpeg-turbo-${ver_libjpeg_turbo}.tar.gz"{.part,}
    fi

    if [ ! -e "$startdir/src/libtiff-${ver_libtiff}.tar.gz" ]
    then
        msg_info "fetch libtiff $ver_libtiff"
        wget -c -O "$startdir/src/libtiff-${ver_libtiff}.tar.gz.part" http://download.osgeo.org/libtiff/tiff-${ver_libtiff}.tar.gz
        mv "$startdir/src/libtiff-${ver_libtiff}.tar.gz"{.part,}
    fi

    if [ ! -e "$startdir/src/giflib-${ver_giflib}.tar.bz2" ]
    then
        msg_info "fetch giflib $ver_giflib"
        wget -c -O "$startdir/src/giflib-${ver_giflib}.tar.bz2.part" http://downloads.sourceforge.net/sourceforge/giflib/giflib-${ver_giflib}.tar.bz2
        mv "$startdir/src/giflib-${ver_giflib}.tar.bz2"{.part,}
    fi

    if [ -e "$startdir/src/libwebp" ]
    then
        if [ "$BUILD_NO_UPDATE" == "1" ]
        then
            msg_warn 'Not updating libwebp since $BUILD_NO_UPDATE=1'
        else
            msg_info 'git fetch libwebp'
            cd "$startdir/src/libwebp"
            git fetch --prune --progress origin master || msg_warn 'Failed to update libwebp. You may be building an old version.'
        fi
    else
        msg_info 'git clone libwebp'
        git clone --mirror --branch master --depth 1 --single-branch --progress https://github.com/webmproject/libwebp.git "$startdir/src/libwebp"
    fi

    if [ ! -e "$startdir/src/libmikmod-${ver_libmikmod}.tar.gz" ]
    then
        msg_info "fetch libmikmod $ver_libmikmod"
        wget -c -O "$startdir/src/libmikmod-${ver_libmikmod}.tar.gz.part" http://downloads.sourceforge.net/sourceforge/mikmod/libmikmod/${ver_libmikmod}/libmikmod-${ver_libmikmod}.tar.gz
        mv "$startdir/src/libmikmod-${ver_libmikmod}.tar.gz"{.part,}
    fi

    if [ ! -e "$startdir/src/libogg-${ver_libogg}.tar.xz" ]
    then
        msg_info "fetch libogg $ver_libogg"
        wget -c -O "$startdir/src/libogg-${ver_libogg}.tar.xz.part" http://downloads.xiph.org/releases/ogg/libogg-${ver_libogg}.tar.xz
        mv "$startdir/src/libogg-${ver_libogg}.tar.xz"{.part,}
    fi

    if [ ! -e "$startdir/src/libvorbis-${ver_libvorbis}.tar.xz" ]
    then
        msg_info "fetch libvorbis $ver_libvorbis"
        wget -c -O "$startdir/src/libvorbis-${ver_libvorbis}.tar.xz.part" http://downloads.xiph.org/releases/vorbis/libvorbis-${ver_libvorbis}.tar.xz
        mv "$startdir/src/libvorbis-${ver_libvorbis}.tar.xz"{.part,}
    fi

    if [ ! -e "$startdir/src/flac-${ver_flac}.tar.xz" ]
    then
        msg_info "fetch flac $ver_flac"
        wget -c -O "$startdir/src/flac-${ver_flac}.tar.xz.part" http://downloads.xiph.org/releases/flac/flac-${ver_flac}.tar.xz
        mv "$startdir/src/flac-${ver_flac}.tar.xz"{.part,}
    fi

    if [ -e "$startdir/src/smpeg" ]
    then
        if [ "$BUILD_NO_UPDATE" == "1" ]
        then
            msg_warn 'Not updating smpeg since $BUILD_NO_UPDATE=1'
        else
            msg_info 'svn update smpeg'
            svn update "$startdir/src/smpeg" || msg_warn 'Failed to update smpeg. You may be building an old version.'
        fi
    else
        msg_info 'svn checkout smpeg'
        svn checkout svn://svn.icculus.org/smpeg/tags/release_$ver_smpeg "$startdir/src/smpeg"
    fi

    if [ ! -e "$startdir/src/harfbuzz-${ver_harfbuzz}.tar.bz2" ]
    then
        msg_info "fetch harfbuzz $ver_harfbuzz"
        wget -c -O "$startdir/src/harfbuzz-${ver_harfbuzz}.tar.bz2.part" http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-${ver_harfbuzz}.tar.bz2
        mv "$startdir/src/harfbuzz-${ver_harfbuzz}.tar.bz2"{.part,}
    fi

    if [ ! -e "$startdir/src/freetype-${ver_freetype}.tar.bz2" ]
    then
        msg_info "fetch freetype $ver_freetype"
        wget -c -O "$startdir/src/freetype-${ver_freetype}.tar.bz2.part" http://download.savannah.gnu.org/releases/freetype/freetype-${ver_freetype}.tar.bz2
        mv "$startdir/src/freetype-${ver_freetype}.tar.bz2"{.part,}
    fi

    if [ ! -e "$startdir/src/lua-${ver_lua}.tar.gz" ]
    then
        msg_info "fetch lua $ver_lua"
        wget -c -O "$startdir/src/lua-${ver_lua}.tar.gz.part" http://www.lua.org/ftp/lua-${ver_lua}.tar.gz
        mv "$startdir/src/lua-${ver_lua}.tar.gz"{.part,}
    fi

    cd "$startdir"
}
build_prepare() {
    [ "$build_envcheck_ok" != "1" ] && build_envcheck
    cd "$startdir"
    msg_info 'Extracting source code'
    rm -rf "$startdir/build"
    mkdir -p "$startdir/build"
    git clone "$startdir/src/ONScripter-CN" "$startdir/build/ONScripter-CN"
    tar xzf "$startdir/src/SDL-${ver_SDL}.tar.gz" -C "$startdir/build"
    tar xzf "$startdir/src/SDL_image-${ver_SDL_image}.tar.gz" -C "$startdir/build"
    tar xzf "$startdir/src/SDL_mixer-${ver_SDL_mixer}.tar.gz" -C "$startdir/build"
    tar xzf "$startdir/src/SDL_ttf-${ver_SDL_ttf}.tar.gz" -C "$startdir/build"
    tar xzf "$startdir/src/libiconv-${ver_libiconv}.tar.gz" -C "$startdir/build"
    tar xzf "$startdir/src/bzip2-${ver_bzip2}.tar.gz" -C "$startdir/build"
    tar xzf "$startdir/src/zlib-${ver_zlib}.tar.gz" -C "$startdir/build"
    tar xJf "$startdir/src/libpng-${ver_libpng}.tar.xz" -C "$startdir/build"
    tar xzf "$startdir/src/libjpeg-turbo-${ver_libjpeg_turbo}.tar.gz" -C "$startdir/build"
    tar xzf "$startdir/src/libtiff-${ver_libtiff}.tar.gz" -C "$startdir/build"
    tar xjf "$startdir/src/giflib-${ver_giflib}.tar.bz2" -C "$startdir/build"
    git clone "$startdir/src/libwebp" "$startdir/build/libwebp"
    tar xzf "$startdir/src/libmikmod-${ver_libmikmod}.tar.gz" -C "$startdir/build"
    tar xJf "$startdir/src/libogg-${ver_libogg}.tar.xz" -C "$startdir/build"
    tar xJf "$startdir/src/libvorbis-${ver_libvorbis}.tar.xz" -C "$startdir/build"
    tar xJf "$startdir/src/flac-${ver_flac}.tar.xz" -C "$startdir/build"
    cp -a "$startdir/src/smpeg" "$startdir/build/"
    tar xjf "$startdir/src/harfbuzz-${ver_harfbuzz}.tar.bz2" -C "$startdir/build"
    tar xjf "$startdir/src/freetype-${ver_freetype}.tar.bz2" -C "$startdir/build"
    tar xzf "$startdir/src/lua-${ver_lua}.tar.gz" -C "$startdir/build"

    msg_info 'Patching source code'

    msg_info 'Patching bzip2'
    sed -i -e 's/sys\\stat.h/sys\/stat.h/' "$startdir/build/bzip2-$ver_bzip2/bzip2.c"

    msg_info 'Patching libpng-apng'
    cd "$startdir/build/libpng-$ver_libpng"
    gzip -c -d "$startdir/src/libpng-$ver_libpng-apng.patch.gz" | patch -N -p1

    msg_info 'Patching libtiff'
    cd "$startdir/build/tiff-$ver_libtiff"
    patch -N -p0 -i "$startdir/src/libtiff-patch/tiff-4.0.3-tiff2pdf-colors.patch"
    patch -N -p1 -i "$startdir/src/libtiff-patch/tiff-3.9.7-CVE-2012-4447.patch"
    patch -N -p1 -i "$startdir/src/libtiff-patch/tiff-3.9.7-CVE-2012-4564.patch"
    patch -N -p1 -i "$startdir/src/libtiff-patch/tiff-4.0.3-CVE-2013-1960.patch"
    patch -N -p1 -i "$startdir/src/libtiff-patch/tiff-4.0.3-CVE-2013-1961.patch"
    patch -N -p1 -i "$startdir/src/libtiff-patch/tiff-4.0.3-libjpeg-turbo.patch"
    patch -N -p1 -i "$startdir/src/libtiff-patch/libtiff-CVE-2013-4244.patch"
    cd "$startdir/build/tiff-$ver_libtiff/tools"
    patch -N -p0 -i "$startdir/src/libtiff-patch/tiff-4.0.3-CVE-2013-4231.patch"
    patch -N -p0 -i "$startdir/src/libtiff-patch/tiff-4.0.3-CVE-2013-4232.patch"

    msg_info 'Patching SDL_mixer'
    echo 'int main(void){return 0;}' >"$startdir/build/SDL_mixer-$ver_SDL_mixer/playmus.c"
    echo 'int main(void){return 0;}' >"$startdir/build/SDL_mixer-$ver_SDL_mixer/playwave.c"

    msg_info 'Patching SDL_ttf'
    cd "$startdir/build/SDL_ttf-$ver_SDL_ttf"
    patch -N -i "$startdir/src/SDL_ttf-patch/bug1433.patch"
    echo 'int main(void){return 0;}' >"$startdir/build/SDL_ttf-$ver_SDL_ttf/glfont.c"
    echo 'int main(void){return 0;}' >"$startdir/build/SDL_ttf-$ver_SDL_ttf/showfont.c"

    rm -rf "$startdir/lib"
    mkdir -p "$startdir/lib"
    cd "$startdir"
}
build_compile() {
    [ "$build_envcheck_ok" != "1" ] && build_envcheck
    cd "$startdir"
    msg_info 'Start building'
    export AR="$HOSTARCH-ar"
    export CC="$HOSTARCH-gcc"
    export CXX="$HOSTARCH-g++"
    export CFLAGS="$CFLAGS -I$startdir/lib/usr/include -L$startdir/lib/usr/lib -O2 -ffunction-sections -fdata-sections"
    export CXXLAGS="$CXXFLAGS -I$startdir/lib/usr/include -L$startdir/lib/usr/lib -O2 -ffunction-sections -fdata-sections"
    export CPPFLAGS="$CPPFLAGS -I$startdir/lib/usr/include"
    export LDFLAGS="$LDFLAGS -L$startdir/lib/usr/lib -Wl,--gc-sections"
    export MAKEFLAGS="$MAKEFLAGS -j$(nproc || echo 1)"
    export PKG_CONFIG_PATH="$startdir/lib/usr/lib/pkgconfig"

    msg_info 'Building libiconv'
    cd "$startdir/build/libiconv-$ver_libiconv"
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static
    make
    make install

    msg_info 'Building bzip2'
    cd "$startdir/build/bzip2-$ver_bzip2"
    make libbz2.a AR="$AR" CC="$CC" RANLIB="$HOSTARCH-ranlib"
    install libbz2.a "$startdir/lib/usr/lib/libbz2.a"
    cp bzlib.h "$startdir/lib/usr/include/bzlib.h"

    msg_info 'Building zlib'
    cd "$startdir/build/zlib-$ver_zlib"
    make -fwin32/Makefile.gcc SHARED_MODE=0 prefix="$startdir/lib" DESTDIR="$startdir/lib" LIBRARY_PATH=/usr/lib INCLUDE_PATH=/usr/include AR="$AR" CC="$CC" RC="$HOSTARCH-windres" STRIP="$HOSTARCH-strip"
    make -fwin32/Makefile.gcc install SHARED_MODE=0 prefix="$startdir/lib" DESTDIR="$startdir/lib" LIBRARY_PATH=/usr/lib INCLUDE_PATH=/usr/include AR="$AR" CC="$CC" RC="$HOSTARCH-windres" STRIP="$HOSTARCH-strip"

    msg_info 'Building libpng'
    cd "$startdir/build/libpng-$ver_libpng"
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static
    make
    make install

    msg_info 'Building libjpeg-turbo'
    cd "$startdir/build/libjpeg-turbo-$ver_libjpeg_turbo"
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static
    make
    make install

    msg_info 'Building libtiff'
    cd "$startdir/build/tiff-$ver_libtiff"
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static
    make
    make install

    msg_info 'Building giflib'
    cd "$startdir/build/giflib-$ver_giflib"
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static
    make
    make install

    msg_info 'Building libwebp'
    cd "$startdir/build/libwebp"
    ./autogen.sh
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static
    make
    make install

    msg_info 'Building libmikmod'
    cd "$startdir/build/libmikmod-$ver_libmikmod"
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static --disable-alsa --disable-pulseaudio --disable-oss --disable-osx --disable-mac --enable-win --enable-ds --disable-dl
    make
    make install

    msg_info 'Building libogg'
    cd "$startdir/build/libogg-$ver_libogg"
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static
    make
    make install

    msg_info 'Building libvorbis'
    cd "$startdir/build/libvorbis-$ver_libvorbis"
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static
    make
    make install

    msg_info 'Building flac'
    cd "$startdir/build/flac-$ver_flac"
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static
    make
    make install

    msg_info 'Building freetype (1 pass)'
    cd "$startdir/build/freetype-$ver_freetype"
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static --without-harfbuzz
    make CFLAGS="$CPPFLAGS -c -I$startdir/lib/usr/include/harfbuzz"
    make install
    make distclean

    msg_info 'Building harfbuzz'
    cd "$startdir/build/harfbuzz-$ver_harfbuzz"
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static --without-glib --without-gobject --without-cairo --without-icu --without-graphite2 --with-freetype --without-uniscribe --without-coretext
    make
    make install

    msg_info 'Building freetype (2 pass)'
    cd "$startdir/build/freetype-$ver_freetype"
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static --with-harfbuzz
    make CFLAGS="$CPPFLAGS -c -I$startdir/lib/usr/include/harfbuzz"
    make install

    msg_info 'Building lua'
    cd "$startdir/build/lua-$ver_lua"
    make PLAT=mingw INSTALL_TOP="$startdir/lib/usr" CC="$CC" MYCFLAGS="$CFLAGS" AR="$AR rcu" RANLIB="$HOSTARCH-ranlib"
    make install PLAT=mingw INSTALL_TOP="$startdir/lib/usr" TO_BIN='lua.exe luac.exe' CC="$CC" MYCFLAGS="$CFLAGS" AR="$AR rcu" RANLIB="$HOSTARCH-ranlib"

    msg_info 'Building SDL'
    cd "$startdir/build/SDL-$ver_SDL"
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static --disable-stdio-redirect
    make
    make install

    msg_info 'Building smpeg'
    cd "$startdir/build/smpeg"
    ./autogen.sh
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static --disable-gtk-player --disable-gtktest --disable-opengl-player
    make
    make install

    msg_info 'Building SDL_image'
    cd "$startdir/build/SDL_image-$ver_SDL_image"
    LIBS="$LIBS -lmingw32 -lSDLmain -lSDL -lwinmm -lddraw -ldxguid -lwinmm -lddraw -ldxguid -lwebp -lgif -ltiff -ljpeg -lpng" \
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static --disable-jpg-shared --disable-png-shared --disable-tif-shared --disable-webp-shared
    make LIBS="$LIBS -lmingw32 -lSDLmain -lSDL -lwinmm -lddraw -ldxguid -lwinmm -lddraw -ldxguid -lwebp -lgif -ltiff -ljpeg -lpng"
    make install

    msg_info 'Building SDL_mixer'
    cd "$startdir/build/SDL_mixer-$ver_SDL_mixer"
    LIBS="$LIBS -lFLAC -lvorbisfile -lvorbis -logg -lsmpeg -lmikmod" \
    ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static --disable-music-cmd --disable-music-mod --disable-music-ogg-shared --disable-music-flac-shared --disable-music-mp3-shared --disable-smpegtest
    make LIBS="$LIBS -lFLAC -lvorbisfile -lvorbis -logg -lsmpeg -lmikmod"
    make install

    msg_info 'Building SDL_ttf'
    cd "$startdir/build/SDL_ttf-$ver_SDL_ttf"
    CFLAGS="$CFLAGS -lstdc++" ./configure --prefix "$startdir/lib/usr" --host "$HOSTARCH" --disable-shared --enable-static --disable-sdltest
    make CFLAGS="$CFLAGS $(pkg-config freetype2 --cflags) -I$startdir/lib/usr/include/SDL -lstdc++"
    make install

    msg_info 'Building ONScripter-CN'
    cd "$startdir/build/ONScripter-CN/jni/app_onscripter-32bpp/onscripter-20130317"
    cat >Makefile <<EOM
CFLAGS += -c -DWIN32 -D_GNU_SOURCE=1 -D_REENTRANT -DUTF8_CAPTION -DUSE_CDROM -DUSE_OGG_VORBIS
CFLAGS += -I$startdir/lib/usr/include/SDL -I$startdir/lib/usr/include/smpeg
LIBS += -L$startdir/lib/usr/lib
LIBS += -static -static-libgcc -static-libstdc++ -lmingw32 -lSDLmain -lSDL_image -lwebp -lgif -ltiff -ljpeg -lpng -lSDL_mixer -lFLAC++ -lFLAC -lvorbisfile -lvorbis -logg -lmikmod -lSDL_ttf -lharfbuzz -lfreetype -lSDL -lpthread -lsmpeg -llua -lbz2 -lz -lwinmm -lddraw -ldxguid -lgdi32 -mwindows
OBJSUFFIX = .o
CC = $HOSTARCH-g++
LD = $HOSTARCH-g++ -o
TARGET = onscripter
include Makefile.onscripter
EOM
    make

    msg_info 'Compressing ONScripter-CN'
    install -Dm0755 onscripter "$startdir/onscripter_g.exe"
    "$HOSTARCH-strip" -s onscripter
    rm -f "$startdir/onscripter.exe"
    if upx --best -o"$startdir/onscripter.exe" onscripter
    then
        chmod 755 "$startdir/onscripter.exe" || true
    else
        msg_warn 'Failed to compress executable with UPX'
        install -Dm0755 onscripter "$startdir/onscripter.exe"
    fi

    msg_info 'Successfully built'
    cd "$startdir"
}
main() {
    build_envcheck
    build_fetch
    build_prepare
    build_compile
}
if [ "$BASH_SOURCE" == "$0" ]
then
    main 2>&1 | tee build.log
fi
