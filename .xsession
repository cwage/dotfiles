export PATH=~/bin:$PATH
xsetroot -solid grey &
xset m 1/8 2
xinput set-prop 11 249 1 &
unity-settings-daemon &
nm-applet &
xmms2d &
#gnome-screensaver &
xscreensaver &
xautolock -locker ~/bin/xscreensaver-lock -time 10 -corners 0+00 -cornerdelay 2 &
udisks-glue --config .udisks-glue.conf &
xrdb ~/.Xresources
#xmodmap .Xmodmap
~/.dropbox-dist/dropboxd &
#smbnetfs ~/smb &
#diodon &
#afuse -o mount_template="sshfs %r:/ %m" -o unmount_template="fusermount -u -z %m" ~/sshfs/ &
#ssh-add
/usr/local/bin/emacs --daemon &
volumeicon &
shutter &
syncthing &
#fluxgui &
gkrellm &
redshift-gtk &
killall -9 syndaemon && syndaemon -i 0.2 -K -R &
exec awesome -c ~/.config/awesome/rc.lua
