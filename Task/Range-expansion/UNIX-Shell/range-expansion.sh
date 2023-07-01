#!/usr/bin/bash

range_expand () (
    IFS=,
    set -- $1
    n=$#
    for element; do
        if [[ $element =~ ^(-?[0-9]+)-(-?[0-9]+)$ ]]; then
            set -- "$@" $(eval echo "{${BASH_REMATCH[1]}..${BASH_REMATCH[2]}}")
        else
            set -- "$@" $element
        fi
    done
    shift $n
    echo "$@"
    # to return a comma-separated value: echo "${*// /,}"
)

range_expand "-6,-3--1,3-5,7-11,14,15,17-20"
