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

# close shell if hour of activity
export TMOUT=3600
