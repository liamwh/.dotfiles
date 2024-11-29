#!/bin/zsh
if [[ "$(uname)" == "Darwin" ]]; then
    {
        setopt NULL_GLOB
        files=($HOME/Downloads/MSTeams/*.yuv)
        if (( ${#files[@]} > 0 )); then
            rm -v "${files[@]}"
        fi
        unsetopt NULL_GLOB
    } &!
fi
