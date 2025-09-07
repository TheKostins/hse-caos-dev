autoload -U colors && colors
if [[ $EUID -eq 0 ]]; then
  PROMPT="%{$fg[green]%}%n%{$reset_color%}@%{$fg[yellow]%}%m %{$fg[blue]%}%~ %{$fg[red]%}#%{$reset_color%} "
else
  PROMPT="%{$fg[green]%}%n%{$reset_color%}@%{$fg[yellow]%}%m %{$fg[blue]%}%~ %{$fg[green]%}$%{$reset_color%} "
fi

export ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ -r "$ZINIT_HOME/zinit.zsh" ]] && source "$ZINIT_HOME/zinit.zsh"

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light junegunn/fzf
zinit light junegunn/fzf-bin

eval "$(dircolors -b)"
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'

alias vim="nvim"

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=magenta'

autoload -Uz compinit
compinit -C

