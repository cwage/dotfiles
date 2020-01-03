export PATH=~/bin:$PATH
xsetroot -solid grey &
xset m 1/8 2
xinput set-prop 11 249 1 &
nm-applet &
xmms2d &
xscreensaver &
xautolock -locker ~/bin/xscreensaver-lock -time 10 -corners 0+00 -cornerdelay 2 &
xrdb ~/.Xresources
xmodmap .Xmodmap
/usr/local/bin/emacs --daemon &
volumeicon &
flameshot &
redshift-gtk &
exec awesome -c ~/.config/awesome/rc.lua
