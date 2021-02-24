xsetroot -solid grey &
xset m 1/8 2
xinput set-prop 11 249 1 &
nm-applet &
xmms2d &
xscreensaver &
xautolock -locker ~/bin/xscreensaver-lock -time 10 -corners 0+00 -cornerdelay 2 &
xrdb ~/.Xresources
#xmodmap .Xmodmap
#smbnetfs ~/smb &
#diodon &
#afuse -o mount_template="sshfs %r:/ %m" -o unmount_template="fusermount -u -z %m" ~/sshfs/ &
#ssh-add
emacs --daemon &
volumeicon &
shutter &
redshift-gtk &
#setxkbmap -option ctrl:swapcaps
#if [ -d $HOME/.xkb/keymap ]; then
#  setxkbmap -types local -print | \
#    sed -e '/xkb_symbols/s/"[[:space:]]/+local&/' > $HOME/.xkb/keymap/custom
#  xkbcomp -w0 -I$HOME/.xkb -R$HOME/.xkb keymap/custom $DISPLAY
#fi
xrandr --output HDMI-0 --mode 1920x1080
xrandr --output DVI-D-0 --off
exec awesome -c ~/.config/awesome/rc.lua
