#Import template for hellwal
source ~/.cache/hellwal/variables.sh
sh ~/.cache/hellwal/terminal.sh

pokemon-colorscripts -r --no-title
#toilet -t -f mono12 -F metal "ZLugoΣ"   

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
alias dots='codium ~/.dotfiles'

#hacer ls al cambiar de directorio
function chpwd() {
    ls
}
