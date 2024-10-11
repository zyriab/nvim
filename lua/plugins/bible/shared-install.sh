if [[ -z "$SWORD_PATH" ]]; then
    export SWORD_PATH="${HOME}/.sword"

    if [[ -f "~/.bashrc" ]]; then
        echo 'export SWORD_PATH="${HOME}/.sword" >> ~/.bashrc'
    fi

    if [[ -f "~/.zshrc" ]]; then
        echo 'export SWORD_PATH="${HOME}/.sword" >> ~/.zshrc'
    fi
fi

mkdir -p "${SWORD_PATH}/mods.d"

yes "yes" | installmgr -init # create a basic user config file
yes "yes" | installmgr -sc   # sync config with known remote repos

# Sample module installation with CrossWire remote source and KJV module.
yes "yes" | installmgr -r CrossWire      # refresh remote source
yes "yes" | installmgr -ri CrossWire KJV # install KJV module from the remote source

