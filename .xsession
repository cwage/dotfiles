export PATH=~/bin:$PATH
xsetroot -solid grey &
xset m 1/8 2 
xinput set-prop 11 249 1 &
unity-settings-daemon &
nm-applet &
gnome-power-manager &
gnome-sound-applet &
xmms2d &
#gnome-screensaver &
xscreensaver &
sshadd
xautolock -locker ~/bin/xscreensaver-lock -time 10 -corners 0+00 -cornerdelay 2 &
udisks-glue --config .udisks-glue.conf &
smbnetfs /home/cwage/mnt &
xrdb ~/.Xresources
xmodmap .Xmodmap
#keepass2 &
#wmname Sawfish &
awesome -c ~/.config/awesome/rc.lua &
~/.dropbox-dist/dropboxd &
export HOME=/home/cwage/WorkHome/ && /home/cwage/WorkHome/.dropbox-dist/dropboxd &
#xfwm4 &
#sawfish
exec gkrellm
