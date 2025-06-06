# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(git)

# User configuration

#export PATH="$HOME/bin:/run/wrappers/bin:/var/setuid-wrappers:$HOME/.nix-profile/bin:$HOME/.nix-profile/sbin:$HOME/.nix-profile/lib/kde4/libexec:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/nix/var/nix/profiles/default/lib/kde4/libexec:/run/current-system/sw/bin:/run/current-system/sw/sbin:/run/current-system/sw/lib/kde4/libexec:$HOME/.npm-packages/bin"
#
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='emc'
else
  export EDITOR='emc'
fi

export USER_EMAIL="david.tulig@gmail.com"

alias sdr='systemd-run --scope --user'

alias rhlint='fn () { nix-shell -p hlint haskellPackages.haskell-tools-refactor --pure --run "hlint $@" };fn'
alias bbduplicity="duplicity --file-prefix-manifest manifest_ --file-prefix-archive archive_ --file-prefix-signature signature_"

function pak {
    SP=($@)
    category=${SP[1]}
    package=${SP[2]}

    echo "${category}/${package} ~amd64" | tee $HOME/gentoo-config/etc/portage/package.accept_keywords/${package}
}

function lg {
    sudo tail -f "/var/log/${1}"
}

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"

# Load machine specific configuration
if [[ -f $HOME/.zshrc_local ]];
then
    source $HOME/.zshrc_local
fi
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# mspyls on linux can't find the icu lib
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR" ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ -z "$TMUX" ]; then
    # we're not in a tmux session

    if [ ! -z "$SSH_TTY" ]; then
        # We logged in via SSH

        # if ssh auth variable is missing
        if [ -z "$SSH_AUTH_SOCK" ]; then
            export SSH_AUTH_SOCK="$HOME/.ssh/.auth_socket"
        fi

        # if socket is available create the new auth session
        if [ ! -S "$SSH_AUTH_SOCK" ]; then
            `ssh-agent -t 86400 -a $SSH_AUTH_SOCK` > /dev/null 2>&1
            echo $SSH_AGENT_PID > $HOME/.ssh/.auth_pid
        fi

        # if agent isn't defined, recreate it from pid file
        if [ -z $SSH_AGENT_PID ]; then
            export SSH_AGENT_PID=`cat $HOME/.ssh/.auth_pid`
        fi
    fi
fi

alias mpv-ns='mpv --no-osc --osd-on-seek=no'

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

alias ddg='w3m lite.duckduckgo.com'
alias rmr='rm -r'
alias cpr='cp -r'

alias adl='ansible-doc --list'
alias adls='ansible-doc --list | less -S'
alias ad='ansible-doc'

[ -f "/home/dtulig/.ghcup/env" ] && . "/home/dtulig/.ghcup/env" # ghcup-env

if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    export TERM=xterm-256color
    # all my themes are setup for 256
    unset COLORTERM
fi

return 0
