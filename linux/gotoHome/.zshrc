START_TIME=$(date +%s%3N)
# Set environment variables
export EDITOR=nvim
export PATH=/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/matheus/.local/bin:/home/matheus/.cargo/bin:/home/matheus/.npm-global/bin
export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'

# Set history settings
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.zsh_history

# Load plugins
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 
source ~/.zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Set options
setopt autocd
setopt interactive_comments

# Aliases
alias ls='ls --color=auto'
alias lf='lfub'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias df='df -h'
alias free='free -m'
alias more=less

# Functions
video2gif() {
  ffmpeg -y -i "${1}" -vf fps=\${3:-10},scale=\${2:-320}:-1:flags=lanczos,palettegen "${1}.png"
  ffmpeg -i "${1}" -i "${1}.png" -filter_complex "fps=${3:-10},scale=${2:-320}:-1:flags=lanczos[x];[x][1:v]paletteuse" "${1}".gif
  rm "${1}.png"
}

btfo(){
	ffmpeg -i "${1}" btfo.mp4
}

lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

# Load external configurations
if [ -f ~/.aliasrc ]; then
. ~/.aliasrc
fi

if [ -f ~/.zsh/.lf_icons ]; then
. ~/.zsh/.lf_icons
fi


# Basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Edit line in vim with ctrl-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Change cursor shape for different vi modes
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

autoload -U colors && colors	# Load colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PS1='%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '

# Timing
END_TIME=$(date +%s%3N)
TIME_DIFF=$((END_TIME - START_TIME))
# echo "Zshrc loaded in ${TIME_DIFF}ms"
