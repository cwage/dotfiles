# if we have GNU ls, do color stuff
if ls --color -d . >/dev/null 2>&1; then
  eval "$(dircolors ~/.dir_colors)"
	alias ls='ls --color=auto'
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

export PATH=~/bin:$PATH:~/packages:~/git/cwage/ai/botutils

# . ~/dotfiles/.bashrc.laptop

alias ssh="cat ~/.ssh/config.d/* > ~/.ssh/config; ssh"

certdate () {
    echo | openssl s_client -servername $1 -connect $1:443 2> /dev/null | openssl x509 -noout -dates
    }

# Only upgrade a bare `xterm` to 256color, and never inside tmux — tmux sets its
# own TERM (tmux-256color), and overriding it with xterm-256color makes apps emit
# escape sequences tmux misinterprets, smearing redraws. Both are 256-color.
if [ -z "$TMUX" ] && [ "$TERM" = "xterm" ]; then
	export TERM=xterm-256color
fi

# The tmux server inherits its working directory from whichever client first
# spawns it and holds that same directory handle for life — there is no way to
# chdir a running server. Spawn it from inside a gocryptfs vault (~/bin/vault)
# and the next force-close, which happens automatically on every suspend, leaves
# the server pinned to a dead mount; from then on every pane it forks starts with
# an unusable cwd ("getcwd: Transport endpoint is not connected"), and even
# `new-session -c` can't override it. Pre-starting the server from $HOME means it
# can never be anchored anywhere that gets unmounted; sessions still open in
# whatever directory you ran tmux from. start-server is a no-op once a server is
# running, and depends on `exit-empty off` in .tmux.conf — without that the
# session-less server exits before it can claim the spot.
tmux () {
	case " $* " in
		*" -L"*|*" -S"*|*" -V "*|*" -h "*) ;;
		*) ( cd "$HOME" && command tmux start-server ) 2>/dev/null ;;
	esac
	command tmux "$@"
}

# --- Stable SSH agent socket -----------------------------------------------
# Every ssh login gets its own forwarded agent socket (/tmp/ssh-*/agent.*) that
# is deleted when that connection closes. A shell inside a long-lived tmux
# session keeps whatever path was current when it was spawned, so it ends up
# pointing at a dead socket as soon as that particular ssh connection ends.
# Fix: everything uses the stable path ~/.ssh/agent.sock, a symlink retargeted
# to whichever real agent is actually alive. Re-pointing the link also fixes
# already-running processes, since the path they hold never changes.
#
# Picking order: sockets that currently hold keys beat live-but-empty ones,
# newest first; the local X-session agent competes on equal terms with the
# forwarded ones. The prompt hook only re-picks when the link target is gone
# (one stat per prompt). Run `ssh-agent-fix` by hand to force a re-pick.
: "${SSH_AGENT_LINK:=$HOME/.ssh/agent.sock}"

# 0 = live with keys, 1 = live but empty, 2 = dead or unreachable
_ssh_agent_probe () {
	[ -S "$1" ] || return 2
	SSH_AUTH_SOCK="$1" timeout 2 ssh-add -l >/dev/null 2>&1
	case $? in 0) return 0 ;; 1) return 1 ;; *) return 2 ;; esac
}

_ssh_agent_link_to () {
	[ -d "${SSH_AGENT_LINK%/*}" ] || return 1
	ln -sfn "$1" "$SSH_AGENT_LINK.tmp.$$" && mv -f "$SSH_AGENT_LINK.tmp.$$" "$SSH_AGENT_LINK"
}

ssh-agent-fix () {
	local inherited="$SSH_AUTH_SOCK" best= best_rc=2 s rc
	# A fresh login (not inside tmux) arrives with the newest forwarded socket.
	# Make it the link target unless the current target is strictly better.
	if [ -z "$TMUX" ] && [ -n "$inherited" ] && [ "$inherited" != "$SSH_AGENT_LINK" ]; then
		_ssh_agent_probe "$inherited"; rc=$?
		if [ $rc -eq 0 ] || { [ $rc -eq 1 ] && ! _ssh_agent_probe "$SSH_AGENT_LINK"; }; then
			_ssh_agent_link_to "$inherited" && export SSH_AUTH_SOCK="$SSH_AGENT_LINK"
			return
		fi
	fi
	# Keep the current target while it holds keys.
	if _ssh_agent_probe "$SSH_AGENT_LINK"; then
		export SSH_AUTH_SOCK="$SSH_AGENT_LINK"
		return
	fi
	# Re-pick among everything we can find.
	for s in $(ls -t /tmp/ssh-*/agent.* 2>/dev/null) "$inherited"; do
		[ -n "$s" ] && [ -O "$s" ] && [ "$s" != "$SSH_AGENT_LINK" ] || continue
		_ssh_agent_probe "$s"; rc=$?
		if [ $rc -lt $best_rc ]; then
			best="$s"; best_rc=$rc
			[ $rc -eq 0 ] && break
		fi
	done
	if [ -n "$best" ]; then
		_ssh_agent_link_to "$best" && export SSH_AUTH_SOCK="$SSH_AGENT_LINK"
		return
	fi
	# Nothing alive anywhere: leave the link and the inherited path alone so a
	# later `ssh-add` still has somewhere to go.
	return 1
}

_ssh_agent_prompt () {
	if [ "$SSH_AUTH_SOCK" = "$SSH_AGENT_LINK" ] && [ ! -S "$SSH_AGENT_LINK" ]; then
		ssh-agent-fix
	fi
	return 0
}
case ";$PROMPT_COMMAND;" in
	*";_ssh_agent_prompt;"*) ;;
	*) PROMPT_COMMAND="_ssh_agent_prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}" ;;
esac

ssh-agent-fix
# --- end stable SSH agent socket --------------------------------------------

alias e="emacsclient -t -a ''"
alias eb="emacsbare"
alias ec="emacsclient -c -n -a ''"
alias emacsbare="emacs -nw -Q --eval \"(load-theme 'misterioso)\""
alias vim="e"
alias vi="e"
alias emacs="e"
alias vi=vim
alias screen="echo you use tmux now idiot"
alias chrome=brave-browser

alias gist="gh gist create -w"

# Youtube-dl aliases
alias yta='docker run --rm \
  -u $(id -u):$(id -g) \
  -v "$PWD":/workdir \
  -w /workdir \
  jauderho/yt-dlp:latest \
  -f bestaudio \
  --extract-audio \
  --audio-format mp3 \
  --audio-quality 0'

alias ytdl='docker run --rm -i \
  -u $(id -u):$(id -g) \
  -v "$PWD":/workdir \
  -w /workdir \
  jauderho/yt-dlp:latest'

export COLORTERM=truecolor
export GLAMOUR_STYLE=light

# Created by `pipx` on 2025-11-09 18:39:46
export PATH="$PATH:/home/cwage/.local/bin"

# necessary for mpd
export MPD_HOST="$HOME/.config/mpd/socket"

# Track comma (nix-run) usage to identify packages worth installing permanently
, () {
    local cmd="${1:-}"
    if [ -n "$cmd" ]; then
        mkdir -p ~/.local/state
        echo "$(date -Is) $cmd" >> ~/.local/state/comma-usage.log
    fi
    command , "$@"
}

comma-report () {
    if [ ! -f ~/.local/state/comma-usage.log ]; then
        echo "No comma usage logged yet."
        return
    fi
    echo "Comma usage (all time):"
    awk '{print $2}' ~/.local/state/comma-usage.log | sort | uniq -c | sort -rn
}
