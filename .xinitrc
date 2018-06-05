export LANG=en_US.UTF8

if [ -e $HOME/.background-image ]; then
    feh --bg-scale $HOME/.background-image
else
    # Use a solid black background as fallback
    ${pkgs.xorg.xsetroot}/bin/xsetroot -solid black
fi

xrdb -merge .Xresources

exec xmonad
