#!/bin/bash

_d2d_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="shutdown startup init exec help"

    case "${prev}" in
        d2d)
            COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
            return 0
            ;;
        *)
            ;;
    esac
}

complete -F _d2d_completion d2d
