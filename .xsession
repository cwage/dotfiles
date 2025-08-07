xsetroot -solid grey &
#xset m 1/8 2
#xinput set-prop 11 249 1 &
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
#setxkbmap -option ctrl:swapcaps
#if [ -d $HOME/.xkb/keymap ]; then
#  setxkbmap -types local -print | \
#    sed -e '/xkb_symbols/s/"[[:space:]]/+local&/' > $HOME/.xkb/keymap/custom
#  xkbcomp -w0 -I$HOME/.xkb -R$HOME/.xkb keymap/custom $DISPLAY
#fi
xrandr --output DP-0 --mode 1920x1080 --primary
signal-desktop &
#xrandr --output DVI-D-0 --off
#xrandr --output DP-0 --mode 1920x1080
PATH=$PATH:/home/cwage/bin
#rivalcfg -s 500
protonmail-bridge &
udiskie --automount --notify --tray &
opensnitch-ui &
exec awesome -c ~/.config/awesome/rc.lua
#exec xterm
