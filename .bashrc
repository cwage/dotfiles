# if we have GNU ls, do color stuff
if ls --color -d . >/dev/null 2>&1; then
  eval "$(dircolors ~/.dir_colors)"
	alias ls='ls --color=auto'
fi

# Fancy prompt
PS1='\u@\h:\w\$ '

# Nifty programmable completion
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# Fancy xterm titles
if [ -z "$PROMPT_COMMAND" ] && [ "$TERM" == 'xterm' ]; then
	export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
fi

# Include any machine-specific config
if [ -f ~/.bashrc.local ]
then
. ~/.bashrc.local
fi

# it'll change your life man
alias Grep=grep

alias ldapsearch="ldapsearch -x -W"

export EDITOR="vi"

# close shell if hour of activity for non-login shells
#shopt -q login_shell || export TMOUT=300

alias curlbrowser='curl -k -L -I -A '\''Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36'\'''

export PATH=$PATH:~/bin

export HISTSIZE=-1
export HISTFILESIZE=-1

export HISTTIMEFORMAT="%h %d %H:%M:%S> "

export HISTIGNORE="&:ls:[bf]g:exit:pwd:clear:mount:umount:history:man*:cd*"



# Avoid duplicates
export HISTCONTROL=ignoreboth:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

. ~/git/cwage/dotfiles/.bashrc.laptop
