# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE

# Paths
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

# Editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='emc'
else
  export EDITOR='emc'
fi

# Git & Email
export USER_EMAIL="david.tulig@gmail.com"

# Aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'
alias l='ls -l'
alias rmr='rm -r'
alias cpr='cp -r'
alias mpv-ns='mpv --no-osc --osd-on-seek=no'
alias ddg='w3m lite.duckduckgo.com'
alias adl='ansible-doc --list'
alias adls='ansible-doc --list | less -S'
alias ad='ansible-doc'
alias sdr='systemd-run --scope --user'
alias rhlint='fn() { nix-shell -p hlint haskellPackages.haskell-tools-refactor --pure --run "hlint $@"; }; fn'
alias bbduplicity='duplicity --file-prefix-manifest manifest_ --file-prefix-archive archive_ --file-prefix-signature signature_'

# Functions
function pak() {
  local category=$1 package=$2
  [[ -z $category || -z $package ]] && return 1
  echo "${category}/${package} ~amd64" | tee "$HOME/gentoo-config/etc/portage/package.accept_keywords/$package"
}

function lg() {
  [[ -z $1 ]] && return 1
  sudo tail -f "/var/log/$1"
}

# Base16
BASE16_SHELL="$HOME/.config/base16-shell/"
[[ -n $PS1 && -s "$BASE16_SHELL/profile_helper.sh" ]] && source "$BASE16_SHELL/profile_helper.sh"

# Local config
[[ -f $HOME/.zshrc_local ]] && source $HOME/.zshrc_local

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# .NET
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

# nvm
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# SSH agent (non-tmux, SSH sessions only)
if [[ -z $TMUX && -n $SSH_TTY ]]; then
  export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-$HOME/.ssh/.auth_socket}"
  if [[ ! -S $SSH_AUTH_SOCK ]]; then
    eval "$(ssh-agent -t 86400 -a $SSH_AUTH_SOCK)" >/dev/null 2>&1
    echo $SSH_AGENT_PID > $HOME/.ssh/.auth_pid
  elif [[ -z $SSH_AGENT_PID ]]; then
    export SSH_AGENT_PID=$(< $HOME/.ssh/.auth_pid)
  fi
fi

# SDKMAN
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ghcup
[[ -f "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"

# Terminal settings
if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
  export TERM=xterm-256color
  unset COLORTERM
fi

# Tools
export FZF_DEFAULT_OPTS="
  --color=bg+:0,bg:-1,border:8
  --color=spinner:4,hl:4
  --color=fg:-1,header:4
  --color=info:4,pointer:4
  --color=marker:3,fg+:7
  --color=prompt:4,hl+:6
"

eval "$(fzf --zsh)"
eval "$(starship init zsh)"

return 0
