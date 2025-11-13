# Include .bashrc, if it exists
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

if [ -z "$PROMPT_COMMAND" ] && [ $TERM == 'xterm' ]; then
	export PROMPT_COMMAND='echo -ne "\033]0;Login: ${USER}@${HOSTNAME}: ${PWD}\007"'
fi


# Created by `pipx` on 2025-11-09 18:39:46
export PATH="$PATH:/home/cwage/.local/bin"
