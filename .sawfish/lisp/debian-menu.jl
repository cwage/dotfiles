;; This is -*-Lisp-*-
;; Automagically generated file.  Do not edit (see /usr/doc/menu/html/index.html)

(provide 'debian-menu)

(defvar debian-applications-accessibility-menu
	(list
	'("Xmag" (system "exec xmag &"))))
(defvar debian-applications-editors-menu
	(list
	'("Gedit" (system "exec /usr/bin/gedit &"))
	'("Nano" (system "exec x-terminal-emulator  -T \"Nano\" -e sh -c \"/bin/nano\" &"))
	'("Xedit" (system "exec xedit &"))))
(defvar debian-applications-file-management-menu
	(list
	'("Baobab" (system "exec /usr/bin/baobab &"))
	'("Brasero" (system "exec /usr/bin/brasero &"))
	'("File-Roller" (system "exec /usr/bin/file-roller &"))
	'("K3b" (system "exec /usr/bin/k3b &"))
	'("Nautilus" (system "exec /usr/bin/nautilus &"))))
(defvar debian-applications-graphics-menu
	(list
	'("Hugin" (system "exec /usr/bin/hugin &"))
	'("ImageMagick" (system "exec /usr/bin/display.im6 logo: &"))
	'("LibreOffice Draw" (system "exec /usr/bin/libreoffice --draw &"))
	'("PTBatcherGUI" (system "exec /usr/bin/PTBatcherGUI &"))
	'("The GIMP" (system "exec /usr/bin/gimp &"))
	'("X Window Snapshot" (system "exec xwd | xwud &"))))
(defvar debian-applications-network-communication-menu
	(list
	'("Irssi" (system "exec x-terminal-emulator  -T \"Irssi\" -e sh -c \"/usr/bin/irssi\" &"))
	'("mangler" (system "exec /usr/bin/mangler &"))
	'("Minicom" (system "exec x-terminal-emulator  -T \"Minicom\" -e sh -c \"/usr/bin/minicom\" &"))
	'("Minicom (X11)" (system "exec /usr/bin/xminicom &"))
	'("Mutt" (system "exec x-terminal-emulator  -T \"Mutt\" -e sh -c \"/usr/bin/mutt\" &"))
	'("Pidgin" (system "exec /usr/bin/pidgin &"))
	'("Remmina" (system "exec /usr/bin/remmina &"))
	'("Telnet" (system "exec x-terminal-emulator  -T \"Telnet\" -e sh -c \"/usr/bin/telnet\" &"))
	'("Xbiff" (system "exec xbiff &"))))
(defvar debian-applications-network-file-transfer-menu
	(list
	'("Transmission BitTorrent Client (Qt)" (system "exec /usr/bin/transmission-qt &"))))
(defvar debian-applications-network-monitoring-menu
	(list
	'("Mtr" (system "exec mtr &"))))
(defvar debian-applications-network-menu
	(list
	'("Communication" . debian-applications-network-communication-menu)
	'("File Transfer" . debian-applications-network-file-transfer-menu)
	'("gtk-gnutella" (system "exec /usr/bin/gtk-gnutella &"))
	'("Monitoring" . debian-applications-network-monitoring-menu)))
(defvar debian-applications-office-menu
	(list
	'("LibreOffice Calc" (system "exec /usr/bin/libreoffice --calc &"))
	'("LibreOffice Impress" (system "exec /usr/bin/libreoffice --impress &"))
	'("LibreOffice Writer" (system "exec /usr/bin/libreoffice --writer &"))
	'("Vym" (system "exec /usr/bin/vym &"))))
(defvar debian-applications-programming-menu
	(list
	'("GDB" (system "exec x-terminal-emulator  -T \"GDB\" -e sh -c \"/usr/bin/gdb\" &"))
	'("GNU Smalltalk" (system "exec x-terminal-emulator  -T \"GNU Smalltalk\" -e sh -c \"/usr/bin/gst\" &"))
	'("Python (v2.7)" (system "exec x-terminal-emulator  -T \"Python (v2.7)\" -e sh -c \"/usr/bin/python2.7\" &"))
	'("Python (v3.4)" (system "exec x-terminal-emulator  -T \"Python (v3.4)\" -e sh -c \"/usr/bin/python3.4\" &"))
	'("Ruby (irb1.9.1)" (system "exec x-terminal-emulator  -T \"Ruby (irb1.9.1)\" -e sh -c \"/usr/bin/irb1.9.1\" &"))
	'("Tclsh8.5" (system "exec x-terminal-emulator  -T \"Tclsh8.5\" -e sh -c \"/usr/bin/tclsh8.5\" &"))
	'("Tclsh8.6" (system "exec x-terminal-emulator  -T \"Tclsh8.6\" -e sh -c \"/usr/bin/tclsh8.6\" &"))
	'("TkWish8.5" (system "exec x-terminal-emulator -e /usr/bin/wish8.5 &"))
	'("TkWish8.6" (system "exec x-terminal-emulator -e /usr/bin/wish8.6 &"))))
(defvar debian-applications-science-mathematics-menu
	(list
	'("Bc" (system "exec x-terminal-emulator  -T \"Bc\" -e sh -c \"/usr/bin/bc\" &"))
	'("Dc" (system "exec x-terminal-emulator  -T \"Dc\" -e sh -c \"/usr/bin/dc\" &"))
	'("LibreOffice Math" (system "exec /usr/bin/libreoffice --math &"))
	'("Xcalc" (system "exec xcalc &"))))
(defvar debian-applications-science-menu
	(list
	'("Mathematics" . debian-applications-science-mathematics-menu)))
(defvar debian-applications-shells-menu
	(list
	'("Bash" (system "exec x-terminal-emulator  -T \"Bash\" -e sh -c \"/bin/bash --login\" &"))
	'("Dash" (system "exec x-terminal-emulator  -T \"Dash\" -e sh -c \"/bin/dash -i\" &"))
	'("Sh" (system "exec x-terminal-emulator  -T \"Sh\" -e sh -c \"/bin/sh --login\" &"))))
(defvar debian-applications-sound-menu
	(list
	'("Audacity" (system "exec /usr/bin/audacity &"))
	'("pavucontrol" (system "exec /usr/bin/pavucontrol &"))
	'("Rhythmbox" (system "exec /usr/bin/rhythmbox &"))))
(defvar debian-applications-system-administration-menu
	(list
	'("DSL/PPPoE configuration tool" (system "exec x-terminal-emulator  -T \"DSL/PPPoE configuration tool\" -e sh -c \"/usr/sbin/pppoeconf\" &"))
	'("Editres" (system "exec editres &"))
	'("fspanel" (system "exec /usr/bin/fspanel &"))
	'("GNOME partition editor" (system "exec su-to-root -X -c /usr/sbin/gparted &"))
	'("pppconfig" (system "exec x-terminal-emulator  -T \"pppconfig\" -e sh -c \"su-to-root -p root -c /usr/sbin/pppconfig\" &"))
	'("stalonetray" (system "exec /usr/bin/stalonetray &"))
	'("TeXconfig" (system "exec x-terminal-emulator  -T \"TeXconfig\" -e sh -c \"/usr/bin/texconfig\" &"))
	'("Xclipboard" (system "exec xclipboard &"))
	'("Xfontsel" (system "exec xfontsel &"))
	'("Xkill" (system "exec xkill &"))
	'("Xrefresh" (system "exec xrefresh &"))))
(defvar debian-applications-system-hardware-menu
	(list
	'("Xvidtune" (system "exec xvidtune &"))))
(defvar debian-applications-system-language-environment-menu
	(list
	'("Input Method Configuration" (system "exec x-terminal-emulator  -T \"Input Method Configuration\" -e sh -c \"/usr/bin/im-config\" &"))))
(defvar debian-applications-system-monitoring-menu
	(list
	'("GKrellM" (system "exec /usr/bin/gkrellm &"))
	'("GNOME system monitor" (system "exec /usr/bin/gnome-system-monitor &"))
	'("Pstree" (system "exec x-terminal-emulator  -T \"Pstree\" -e sh -c \"/usr/bin/pstree.x11\" &"))
	'("Top" (system "exec x-terminal-emulator  -T \"Top\" -e sh -c \"/usr/bin/top\" &"))
	'("Xconsole" (system "exec xconsole -file /dev/xconsole &"))
	'("Xev" (system "exec x-terminal-emulator -e xev &"))
	'("Xload" (system "exec xload &"))))
(defvar debian-applications-system-package-management-menu
	(list
	'("Synaptic Package Manager" (system "exec x-terminal-emulator -e synaptic-pkexec &"))))
(defvar debian-applications-system-security-menu
	(list
	'("keepass2" (system "exec /usr/bin/keepass2 &"))
	'("Seahorse" (system "exec /usr/bin/seahorse &"))))
(defvar debian-applications-system-menu
	(list
	'("Administration" . debian-applications-system-administration-menu)
	'("Hardware" . debian-applications-system-hardware-menu)
	'("Language Environment" . debian-applications-system-language-environment-menu)
	'("Monitoring" . debian-applications-system-monitoring-menu)
	'("Package Management" . debian-applications-system-package-management-menu)
	'("Security" . debian-applications-system-security-menu)))
(defvar debian-applications-terminal-emulators-menu
	(list
	'("Gnome Terminal" (system "exec /usr/bin/gnome-terminal &"))
	'("XTerm" (system "exec xterm &"))
	'("X-Terminal as root (GKsu)" (system "exec /usr/bin/gksu -u root /usr/bin/x-terminal-emulator &"))
	'("XTerm (Unicode)" (system "exec uxterm &"))))
(defvar debian-applications-text-menu
	(list
	'("Character map" (system "exec /usr/bin/gucharmap &"))))
(defvar debian-applications-video-menu
	(list
	'("Totem" (system "exec /usr/bin/totem &"))
	'("VLC media player" (system "exec /usr/bin/qvlc &"))))
(defvar debian-applications-viewers-menu
	(list
	'("Evince" (system "exec /usr/bin/evince &"))
	'("Eye of GNOME" (system "exec /usr/bin/eog &"))
	'("gThumb Image Viewer" (system "exec /usr/bin/gthumb &"))
	'("Shotwell" (system "exec /usr/bin/shotwell &"))
	'("Xditview" (system "exec xditview &"))
	'("XDvi" (system "exec /usr/bin/xdvi &"))))
(defvar debian-applications-menu
	(list
	'("Accessibility" . debian-applications-accessibility-menu)
	'("Editors" . debian-applications-editors-menu)
	'("File Management" . debian-applications-file-management-menu)
	'("Graphics" . debian-applications-graphics-menu)
	'("Network" . debian-applications-network-menu)
	'("Office" . debian-applications-office-menu)
	'("Programming" . debian-applications-programming-menu)
	'("Science" . debian-applications-science-menu)
	'("Shells" . debian-applications-shells-menu)
	'("Sound" . debian-applications-sound-menu)
	'("System" . debian-applications-system-menu)
	'("Terminal Emulators" . debian-applications-terminal-emulators-menu)
	'("Text" . debian-applications-text-menu)
	'("Video" . debian-applications-video-menu)
	'("Viewers" . debian-applications-viewers-menu)))
(defvar debian-crossover-menu
	(list
	'("CrossOver" (system "exec /home/cwage/cxoffice/bin/crossover &"))
	'("Uninstall CrossOver Linux" (system "exec /home/cwage/cxoffice/bin/cxuninstall &"))))
(defvar debian-games-blocks-menu
	(list
	'("TINT Is Not Tetris(tm)" (system "exec x-terminal-emulator  -T \"TINT Is Not Tetris(tm)\" -e sh -c \"sh -c '/usr/games/tint -l 5;echo;echo PRESS ENTER;read line'\" &"))))
(defvar debian-games-board-menu
	(list
	'("Chess Net" (system "exec x-terminal-emulator  -T \"Chess Net\" -e sh -c \"/usr/games/xboard -ics -icshost chess.net\" &"))
	'("Default" (system "exec x-terminal-emulator  -T \"Default\" -e sh -c \"/usr/games/xboard -ics\" &"))
	'("Free I.C.S." (system "exec x-terminal-emulator  -T \"Free I.C.S.\" -e sh -c \"/usr/games/xboard -ics -icshost freechess.org\" &"))
	'("Internet Chess Club" (system "exec x-terminal-emulator  -T \"Internet Chess Club\" -e sh -c \"/usr/games/xboard -ics -icshost chessclub.com\" &"))
	'("Scid" (system "exec /usr/games/scid &"))
	'("XBoard" (system "exec /usr/games/xboard -xncp &"))
	'("XBoard (passive chessboard)" (system "exec /usr/games/xboard -ncp &"))))
(defvar debian-games-card-menu
	(list
	'("Gnome Solitaire Games" (system "exec /usr/games/sol &"))))
(defvar debian-games-toys-menu
	(list
	'("Oclock" (system "exec oclock &"))
	'("Xclock (analog)" (system "exec xclock -analog &"))
	'("Xclock (digital)" (system "exec xclock -digital -update 1 &"))
	'("Xeyes" (system "exec xeyes &"))
	'("Xlogo" (system "exec xlogo &"))))
(defvar debian-games-menu
	(list
	'("Blocks" . debian-games-blocks-menu)
	'("Board" . debian-games-board-menu)
	'("Card" . debian-games-card-menu)
	'("Toys" . debian-games-toys-menu)))
(defvar debian-help-menu
	(list
	'("Info" (system "exec x-terminal-emulator  -T \"Info\" -e sh -c \"info\" &"))
	'("TeXdoctk" (system "exec /usr/bin/texdoctk &"))
	'("Xman" (system "exec xman &"))
	'("yelp" (system "exec /usr/bin/yelp &"))))
(defvar debian-screen-locking-menu
	(list
	'("Xtrlock" (system "exec xtrlock &"))))
(defvar debian-screen-menu
	(list
	'("Locking" . debian-screen-locking-menu)))
(defvar debian-window-managers-menu
	(list
	'("awesome" (progn (setq saved-command-line-args '("/usr/bin/awesome")) (restart)))
	'("Sawfish" (progn (setq saved-command-line-args '("/usr/bin/sawfish")) (restart)))
	'("XFwm" (progn (setq saved-command-line-args '("xfwm4")) (restart)))))
(defvar debian-menu
	(list
	'("Applications" . debian-applications-menu)
	'("CrossOver" . debian-crossover-menu)
	'("Games" . debian-games-menu)
	'("Help" . debian-help-menu)
	'("Screen" . debian-screen-menu)
	'("Window Managers" . debian-window-managers-menu)))
