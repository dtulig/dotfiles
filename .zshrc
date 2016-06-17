# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(git)

# User configuration

export PATH="$HOME/bin:/var/setuid-wrappers:$HOME/.nix-profile/bin:$HOME/.nix-profile/sbin:$HOME/.nix-profile/lib/kde4/libexec:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/nix/var/nix/profiles/default/lib/kde4/libexec:/run/current-system/sw/bin:/run/current-system/sw/sbin:/run/current-system/sw/lib/kde4/libexec:$HOME/.npm-packages/bin"

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='emacsclient -c'
else
  export EDITOR='emacsclient -c'
fi

export USER_EMAIL="david.tulig@gmail.com"

# Load machine specific configuration
if [[ -f $HOME/.zshrc_local ]];
then
    source $HOME/.zshrc_local
fi