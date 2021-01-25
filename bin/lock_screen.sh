#!/usr/bin/env bash

#icon="$HOME/scripts/lock.png"
tmpbg='/tmp/screen.png'

#(( $# )) && { icon=$1; }

scrot -o "$tmpbg"
convert "$tmpbg" -scale 10% -scale 1000% "$tmpbg"
#convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"

revert() {
  xset dpms 0 0 0
}

trap revert SIGHUP SIGINT SIGTERM

xset +dpms dpms 600 600 600
i3lock -n -u -i "$tmpbg"
revert
