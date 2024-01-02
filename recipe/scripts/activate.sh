#!/usr/bin/env bash

if [ -n "$ZSH_VERSION" ]; then
    source ${0%.sh}.zsh
    return
fi

if [ "${BASH_VERSINFO:-0}" -lt 4 ]; then
    source ./.env
    return
fi

if [ ! -e "./.env" ]; then
    return
fi

# Parse .env file
unset dotenv_keys && declare -A dotenv_keys
for key in $(
    sed \
    -e 's/^[[:space:]]*//' \
    -e 's/^export[[:space:]]\{1,\}//' \
    -e '/^[^[:space:]#]\{1,\}=/!d' \
    -e 's/=.*//' \
    .env
); do
    dotenv_keys[$key]=""
done

# Preserve environment variables
if [ ! -v "dotenv_stack" ];  then
    declare -A dotenv_stack
fi

## preserve every new .env key
for key in ${!dotenv_keys[@]}; do
    if [[ ! ${dotenv_stack[$key]+_} ]]; then
        dotenv_stack[$key]="${!key}"
    fi
done; unset key

## reset every preserved key that is not in .env
for key in ${!dotenv_stack[@]}; do
    if [[ ! ${dotenv_keys[$key]+_} ]]; then
        export $key="${dotenv_stack[$key]}"
        unset "dotenv_stack[$key]"
    fi
done; unset key

unset dotenv_keys

# Load new environment variables
source ./.env
