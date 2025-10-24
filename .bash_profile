# Include .bashrc, if it exists
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

if [ -z "$PROMPT_COMMAND" ] && [ $TERM == 'xterm' ]; then
	export PROMPT_COMMAND='echo -ne "\033]0;Login: ${USER}@${HOSTNAME}: ${PWD}\007"'
fi

