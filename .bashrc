alias ls='ls --color=auto'
if [[ "$(uname)" == "Darwin" ]]; then
	alias ls='ls -G'
fi

export TERM=xterm-256color
. "$HOME/.cargo/env"
