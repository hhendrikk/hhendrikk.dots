if status is-interactive
set -g fish_prompt_pwd_dir_length 0
set -U fish_greeting ""

alias vim="nvim"
alias l="ls -lha"
alias lg="lazygit"

starship init fish | source
/home/hendrik/.local/bin/mise activate fish | source
zoxide init fish | source
end
