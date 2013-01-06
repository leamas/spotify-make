#!/bin/bash

path=$0
[[ "$path" == /* ]] || path=$PWD/$path
cd ${path%/*}

spotify=../.local/lib/spotify-client/spotify
version=0.8.8.323.gd143501.250

if [ "$1" = '-v' ]; then
    echo Version: $version
    exit 0
fi

# board=http://community.spotify.com/t5/Desktop-Linux
# $board/ANNOUNCE-Spotify-0-8-3-for-GNU-Linux/td-p/60659/page/6
rm -f \$HOME/.cache/spotify/offline.bnk

# 0.8.8: Various reports requiring ~/cache/spotify to be wiped.
[ -f $HOME/.cache/spotify-$version ] || {
    rm -rf  $HOME/.cache/spotify
    touch  $HOME/.cache/spotify-$version
}

# $board/Illegal-Instruction-Client-Crash-Read-Here/td-p/194448
cat /proc/cpuinfo | grep -q 'sse2' || {
    zenity --error --text "Cannot run on this CPU (no sse2 support)"
    exit 1
}

$spotify $@
