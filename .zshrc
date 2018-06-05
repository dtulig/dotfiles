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

# Load machine specific configuration
if [[ -f $HOME/.zshrc_local ]];
then
    source $HOME/.zshrc_local
fi
