#!/usr/bin/env bash

if [ -n "$ZSH_VERSION" ]; then
    source ${0%.sh}.zsh
    return
fi

if [ "${BASH_VERSINFO:-0}" -lt 4 ]; then
    return
fi

# Reset env variables to pre-activation values
for key in ${!dotenv_stack[@]}; do
    export $key="${dotenv_stack[$key]}"
    unset "dotenv_stack[$key]"
done; unset key

# Cleanup
unset dotenv_stack
