# Remove the temp symlink from previous logins
rm -rf /tmp/ssh-agent-sock-screen

# Link /tmp/ssh-agent-sock-screen to $SSH_AUTH_SOCK, which should be the socket
# for an active, running ssh-agent
if [ $SSH_AUTH_SOCK ]; then
	ln -s  $SSH_AUTH_SOCK /tmp/ssh-agent-sock-screen
fi

# Include .bashrc, if it exists
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

if [ -z "$PROMPT_COMMAND" ] && [ $TERM == 'xterm' ]; then
	export PROMPT_COMMAND='echo -ne "\033]0;Login: ${USER}@${HOSTNAME}: ${PWD}\007"'
fi

