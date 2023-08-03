export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

PROMPT='%{$fg[cyan]%}%n@%m %{$fg[yellow]%}%~ %{$reset_color%}$ '

plugins=(git colored-man-pages colorize history-substring-search zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting virtualenv)

alias ll="ls -alF"
alias cls="clear"

export EDITOR="nano"

export PATH="$HOME/bin:$PATH"

autoload -U compinit && compinit

plugins+=(zsh-autosuggestions)
plugins+=(zsh-history-substring-search)
plugins+=(zsh-autosuggestions)
plugins+=(zsh-syntax-highlighting)
plugins+=(virtualenv)

virtualenv_prompt() {
    if [[ -n $VIRTUAL_ENV ]]; then
        echo -n "%{$fg[green]%}($(basename $VIRTUAL_ENV)) "
    fi
}

PROMPT='%{$fg_bold[blue]%}$(virtualenv_prompt)%{$fg[cyan]%}%n@%m %{$fg[yellow]%}%~ %{$reset_color%}$ '

source $ZSH/oh-my-zsh.sh

export CHROME_EXECUTABLE="/usr/bin/microsoft-edge-stable"
export ANDROID_SDK_ROOT="/opt/android-sdk"

export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools/"
export PATH="$PATH:$ANDROID_SDK_ROOT/tools/bin/"
export PATH="$PATH:$ANDROID_ROOT/emulator"
export PATH="$PATH:$ANDROID_SDK_ROOT/tools/"
export PATH="$PATH:$HOME/.pub-cache/bin"
export PATH="$PATH:$HOME/dotfilesdata"
export PATH="$HOME/.tmuxifier/bin:$PATH"
export PATH="~/.npm-global/bin:$PATH"
export PATH="~/.npm-packages/bin:$PATH"
eval "$(tmuxifier init -)"
export TERM='xterm-256color'
alias tmux="TERM=screen-256color-bce tmux"
[ -s "/home/anshiq/.bun/_bun" ] && source "/home/anshiq/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


# bun completions
[ -s "/home/anshik/.bun/_bun" ] && source "/home/anshik/.bun/_bun"
