#!/usr/bin/env sh

DOTFILES_DIR=`pwd`

delete_symlink_if_exists () {
    if [[ -L $1 ]];
    then
        echo "Symlink for $1 already exists, removing before re-linking"
        rm $1
    fi
}

move_file_to_tmp_if_exists () {
    if [[ -f $1 && ! -L $1 ]];
    then
        echo "Moving $1 to /tmp"
        mv $1 /tmp/
    fi
}

symlink () {
    echo "Symlinking $1 $2"
    ln -s $1 $2
}

# Create home bin directory. All bin files will be installed here.
mkdir -p $HOME/bin

# SSH utilities need to be symlinked to bin.
SSH_BIN_FILES=( list_authorized_keys rotate_all_keys setup_ssh_server
                rotate_ssh_key )

for FILE in ${SSH_BIN_FILES[@]}; do
    BIN_FILE=$HOME/bin/$FILE

    move_file_to_tmp_if_exists $BIN_FILE

    # If the symlink exists, remove it and re-link.
    delete_symlink_if_exists $BIN_FILE

    symlink $DOTFILES_DIR/.ssh/${FILE}.sh $BIN_FILE
done

# General config files.
HOME_DIR_FILES=( tmux.conf vimrc xmobarrc zshrc )

# Add X specific configs if on linux.
if [[ "$OSTYPE" == "linux-gnu" ]];
then
    HOME_DIR_FILES+=( xprofile Xresources xsessionrc )
fi

for FILE in ${HOME_DIR_FILES[@]}; do
    # Note: prepending ".".
    FILE=.${FILE}
    HOME_DIR_FILE=${HOME}/${FILE}

    move_file_to_tmp_if_exists $HOME_DIR_FILE

    # If the symlink exists, remove it and re-link.
    delete_symlink_if_exists $HOME_DIR_FILE

    symlink $DOTFILES_DIR/${FILE} $HOME_DIR_FILE
done

HOME_DIR_DIRS=( emacs.d )

# Add Xmonad specific configs if on linux.
if [[ "$OSTYPE" == "linux-gnu" ]];
then
    HOME_DIR_DIRS+=( xmonad )
fi

for DIR in ${HOME_DIR_DIRS[@]}; do
    DIR=.${DIR}
    RESOLVED_DIR=${HOME}/$DIR

    # If the directory is already there, move it to the tmp folder.
    if [[ -d $RESOLVED_DIR && ! -L $RESOLVED_DIR ]];
    then
        echo "Moving $RESOLVED_DIR to /tmp/$RESOLVED_DIR"
        mv $RESOLVED_DIR /tmp/
    fi

    # If the symlink exists, remove it and re-link.
    delete_symlink_if_exists $RESOLVED_DIR

    symlink $DOTFILES_DIR/${DIR} $RESOLVED_DIR
done
