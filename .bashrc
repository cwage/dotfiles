# if we have GNU ls, do color stuff
if ls --color -d . >/dev/null 2>&1; then
  eval "$(dircolors ~/.dir_colors)"
	alias ls='ls --color=auto'
fi

# Ensure Volta-managed Node is on PATH
if [ -d "$HOME/.volta/bin" ] && ! printf '%s' "$PATH" | grep -q "$HOME/.volta/bin"; then
  export PATH="$HOME/.volta/bin:$PATH"
fi

# Ensure Flatpak user apps are on PATH
if [ -d "$HOME/.local/share/flatpak/exports/bin" ] && ! printf '%s' "$PATH" | grep -q "$HOME/.local/share/flatpak/exports/bin"; then
  export PATH="$HOME/.local/share/flatpak/exports/bin:$PATH"
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

# alias ldapsearch="ldapsearch -x -W"

export EDITOR="vi"

# close shell if hour of activity for non-login shells
#shopt -q login_shell || export TMOUT=300

alias curlbrowser='curl -k -L -I -A '\''Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36'\'''

export PATH=$PATH:~/bin:~/packages:~/git/cwage/ai/botutils:~/git/cwage/localai/

# . ~/dotfiles/.bashrc.laptop

alias ssh="cat ~/.ssh/config.d/* > ~/.ssh/config; ssh"

certdate () {
    echo | openssl s_client -servername $1 -connect $1:443 2> /dev/null | openssl x509 -noout -dates
    }

export TERM=xterm-256color

alias e="emacsclient -t -a ''"
alias eb="emacsbare"
alias ec="emacsclient -c -n -a ''"
alias emacsbare="emacs -nw -Q --eval \"(load-theme 'misterioso)\""
alias vim="e"
alias vi="e"
alias emacs="e"
alias vi=vim
alias screen="echo you use tmux now idiot"
alias xmms=xmms2
alias chrome=brave-browser
alias ncspot=io.github.hrkfdn.ncspot

eval "$(~/.rbenv/bin/rbenv init - bash)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias gist="gh gist create -w"

# Created by `pipx` on 2025-11-09 18:39:46
export PATH="$PATH:/home/cwage/.local/bin"
