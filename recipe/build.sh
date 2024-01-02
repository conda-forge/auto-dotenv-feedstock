#!/usr/bin/env bash

for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    for SHELL_EXT in "sh" "zsh"
    do
        cp "${RECIPE_DIR}/scripts/${CHANGE}.${SHELL_EXT}" "${PREFIX}/etc/conda/${CHANGE}.d/${PKG_NAME}.${SHELL_EXT}"
    done
done
