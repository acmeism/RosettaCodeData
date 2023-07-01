#! /bin/bash

indent_print()
{
    for((i=0; i < $1; i++)); do
	echo -ne "\t"
    done
    echo "$2"
}

walk_tree()
{
    local oldifs bn lev pr pmat
    if [[ $# -lt 3 ]]; then
	if [[ $# -lt 2 ]]; then
	    pmat=".*"
	else
	    pmat="$2"
	fi
	walk_tree "$1" "$pmat" 0
	return
    fi
    lev=$3
    [ -d "$1" ] || return
    oldifs=$IFS
    IFS="
"
    for el in $1/*; do
	bn=$(basename "$el")
	if [[ -d "$el" ]]; then
	    indent_print $lev "$bn/"
	    pr=$( walk_tree "$el" "$2" $(( lev + 1)) )
	    echo "$pr"
	else
	    if [[ "$bn" =~ $2 ]]; then
		indent_print $lev "$bn"
	    fi
	fi
    done
    IFS=$oldifs
}

walk_tree "$1" "\.sh$"
