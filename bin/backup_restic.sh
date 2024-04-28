#!/bin/sh

export RESTIC_COMPRESSION=max

if [ -f /home/dtulig/.env-restic ]; then
    source /home/dtulig/.env-restic
else
    echo "Error: .env-restic file not found."
    exit 1
fi

EXCLUDE=".cache .local .cabal .cargo .gradle .m2 .mozilla .npm .nvm .poetry .pyenv .rustup .sdkman .stack .thunderbird .var qemu go"
EXCLUDE_ARR=(${EXCLUDE})

EXCLUDE_P=$(printf -- " --exclude ${BACKUP_DIR}/%s" "${EXCLUDE_ARR[@]}")

lock_file="/tmp/restic_backup.lock"

# Check if lock file exists
if [ -e "$lock_file" ]; then
    echo "Backup process is already running. Exiting."
    exit 1
fi

# Create lock file
touch "$lock_file"

# Define cleanup function
cleanup() {
    rm -f "$lock_file"
}

# Trap SIGINT and SIGTERM signals to perform cleanup
trap 'cleanup; exit 1' INT TERM

# restic
restic -r ${BACKUP_REPO} backup ${BACKUP_DIR} ${EXCLUDE_P} --verbose

# remove lock file
cleanup
