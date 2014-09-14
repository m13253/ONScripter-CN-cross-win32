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
startdir="$(pwd)"
msg_info "Working directory is $startdir"
msg_info 'Checking cross compile toolchain'
[ -z "$HOSTARCH" ] && export HOSTARCH=i686-w64-mingw32
[ -z "$CC" ] && export CC=gcc
if [ -z "$(which "$HOSTARCH-$CC")" ]
then
    msg_error "Cannot find cross compile toolchain for $HOSTARCH"
    exit 2
fi
msg_info 'Fetching source code'
mkdir -p "$startdir/src"
if [ -e "$startdir/src/ONScripter-CN" ]
then
    msg_info 'git fetch src/ONScripter-CN'
    cd "$startdir/src/ONScripter-CN"
    git fetch --prune origin master || msg_warn 'Failed to update ONScripter-CN. You may be building an old version.'
    cd "$startdir"
else
    msg_info 'git clone src/ONScripter-CN'
    git clone --mirror --branch master --depth 1 --single-branch https://github.com/m13253/ONScripter-CN.git "$startdir/src/ONScripter-CN"
fi
msg_info 'Sucessfully updated ONScripter-CN'
msg_info 'Extracting source code'
rm -rf "$startdir/build"
mkdir -p "$startdir/build"
git clone "$startdir/src/ONScripter-CN" "$startdir/build/ONScripter-CN"
msg_info 'Start building'
