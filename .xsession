export PATH=~/bin:$PATH
xsetroot -solid grey &
xset m 1/8 2 
xinput set-prop 11 249 1 &
unity-settings-daemon &
nm-applet &
xmms2d &
gnome-screensaver &
#xscreensaver &
ssh-add
xautolock -locker ~/bin/xscreensaver-lock -time 10 -corners 0+00 -cornerdelay 2 &
udisks-glue --config .udisks-glue.conf &
xrdb ~/.Xresources
xmodmap .Xmodmap
awesome -c ~/.config/awesome/rc.lua &
~/.dropbox-dist/dropboxd &
smbnetfs ~/smb &
diodon &
exec gkrellm
