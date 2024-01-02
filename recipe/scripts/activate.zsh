#!/usr/bin/env zsh

if [ ! -e "./.env" ]; then
    return
fi

# Parse .env file
dotenv_keys=$(
    sed \
    -e 's/^[[:space:]]*//' \
    -e 's/^export[[:space:]]\{1,\}//' \
    -e '/^[^[:space:]#]\{1,\}=/!d' \
    -e 's/=.*//' \
    .env
)
## Split string by spaces
dotenv_keys=$(echo $dotenv_keys | tr '\n' ' ')
dotenv_keys=(${(s/ /)dotenv_keys})

# Preserve environment variables
if (( ! ${+dotenv_stack} )); then
    declare -A dotenv_stack
fi

## preserve every new .env key
for key in $dotenv_keys; do
    if [[ ! ${(k)dotenv_stack[$key]} ]]; then
        dotenv_stack[$key]=${(P)key}
    fi
done; unset key

## reset every preserved key that is not in .env
for key in ${(@k)dotenv_stack}; do
    if (( ! $dotenv_keys[(Ie)$key] )); then
        export $key=$dotenv_stack[$key]
        unset "dotenv_stack[$key]"
    fi
done; unset key

unset dotenv_keys

# Load new environment variables
source ./.env
