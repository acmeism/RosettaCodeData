#!/bin/bash

lcp () {
	local i=0 word c longest

	case $# in
		0)
			return 1
		;;
		1)
			printf %s "$1"
			return
		;;
	esac

	while :; do
		c=
		for word; do
			[[ $i == ${#word} ]] && break 2
			[[ -z $c ]] && c="${word:i:1}"
			[[ ${word:i:1} != "$c" ]] && break 2
		done
		longest+="$c"
		((i++))
	done

	printf %s "$longest"
}

mapfile -t tests <<'TEST'
interspecies	interstellar	interstate
throne	throne
throne	dungeon
throne		throne
cheese

prefix	suffix
foo	foobar
TEST

for test in "${tests[@]}"; do
	mapfile -t -d $'\t' words <<<"$test"
	words=("${words[@]%$'\n'}")
	printf '%s -> "%s"\n' "$(declare -p words)" "$(lcp "${words[@]}")"
done
