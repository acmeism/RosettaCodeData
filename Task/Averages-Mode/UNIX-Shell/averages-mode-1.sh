#!/bin/bash

function mode {
    declare -A map
    max=0
    for x in "$@"; do
	tmp=$((${map[$x]} + 1))
	map[$x]=$tmp
	((tmp > max)) && max=$tmp
    done
    for x in "${!map[@]}"; do
	[[ ${map[$x]} == $max ]] && echo -n "$x "
    done
    echo
}
