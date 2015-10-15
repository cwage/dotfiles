# I like pretty colors
if [ -x /usr/bin/dircolors ]; then
	eval `/usr/bin/dircolors -b`
fi

# if we have GNU ls, do color stuff
if ls --version | grep 'Free Software Foundation' > /dev/null; then
  eval `dircolors ~/.dir_colors`
	alias ls='ls --color=auto'
fi

# Fancy prompt
PS1='\u@\h:\w\$ '

# Nifty programmable completion
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# Fancy xterm titles
if [ -z "$PROMPT_COMMAND" ] && [ $TERM == 'xterm' ]; then
	export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
fi


# Path
export PATH=~/bin:$PATH:/usr/sbin:/usr/local/sbin:/sbin


# Include any machine-specific config
if [ -f ~/.bashrc.local ]
then
. ~/.bashrc.local
fi

alias xmms=xmms2
alias sshadd="ssh-add ~/.ssh/id_ecdsa ~/.ssh/opensky_rsa"


# it'll change your life man
alias Grep=grep

alias xterm="xterm -ls -mc 200"
