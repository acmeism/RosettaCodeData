#!/bin/sh
# search.sh - search an inverted index

unset IFS
: ${INDEX:=index}

want=sequence
while getopts aos name; do
	case "$name" in
	a)	want=all;;
	o)	want=one;;
	s)	want=sequence;;
	*)	exit 2;;
	esac
done
shift $((OPTIND - 1))

all() {
	echo "TODO"
	exit 2
}

one() {
	echo "TODO"
	exit 2
}

sequence() {
	echo "TODO"
	exit 2
}

$want "$@"
