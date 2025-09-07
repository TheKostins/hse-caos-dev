export ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[[ -r "$ZINIT_HOME/zinit.zsh" ]] || { print -ru2 "zinit not found"; exit 1; }
source "$ZINIT_HOME/zinit.zsh"

zinit ice lucid depth=1
zinit light zsh-users/zsh-autosuggestions

zinit ice lucid depth=1 atload'_zsh_highlight_init'
zinit light zsh-users/zsh-syntax-highlighting

zinit ice lucid depth=1
zinit light junegunn/fzf

zinit ice lucid depth=1
zinit light junegunn/fzf-bin

zinit compile -q
