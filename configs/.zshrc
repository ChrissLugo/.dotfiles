source ~/.cache/hellwal/variables.sh
sh ~/.cache/hellwal/terminal.sh

fastfetch
# pokemon-colorscripts -r --no-title
# toilet -t -f mono12 -F metal "ZLinux"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="nicoulaj"


plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh


#zoxide
eval "$(zoxide init zsh)"

# Created by `pipx` on 2025-06-16 20:52:31
export PATH="$PATH:/home/lugo/.local/bin"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=245,bold'

alias ls='lsd'
alias ll='lsd -lh'
alias la='lsd -a'
alias office='onlyoffice-desktopeditors'
alias code='codium'
alias dots='zeditor ~/.dotfiles'
alias zed='zeditor'
alias tesis='zed ~/Projects/Detection-Metabolic-Syndrome & zed ~/Projects/Detection-Metabolic-Syndrome-API & disown'

#hacer ls al cambiar de directorio
# Corrected
function chpwd() {
    ls
}


# Cargar el plugin
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh

# Configurar fzf-tab para que use chafa al previsualizar archivos
zstyle ':fzf-tab:complete:*:*' fzf-preview '
    if [[ -d $realpath ]]; then
        ls --color=always $realpath
    elif [[ -f $realpath ]]; then
        chafa --size=40x40 $realpath
    fi
'

fpath=(~/.zsh/completions $fpath)
