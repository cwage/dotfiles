xsetroot -solid grey &
xwinwrap -ni -b -un -ov -fs -- xterm -into WID -geometry 500x500+0+0 -fa 'Monospace' -fs 6 -e btop &
nm-applet &
xmms2d &
xscreensaver &
xautolock -locker ~/bin/xscreensaver-lock -time 10 -corners 0+00 -cornerdelay 2 &
xrdb ~/.Xresources
# ssh-add
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
slack &
PATH=$PATH:/home/cwage/bin
protonmail-bridge &
# Ensure a polkit authentication agent is available for udiskie actions
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
udiskie --automount --notify --tray &
#opensnitch-ui &
exec awesome -c ~/.config/awesome/rc.lua
#exec xterm
