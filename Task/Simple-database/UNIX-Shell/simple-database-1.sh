#!/bin/sh

db_create() {
	mkdir ./"$1" && mkdir "./$1/.tag" && echo "Create DB \`$1'"
}

db_delete() {
	rm -r ./"$1" && echo "Delete DB \`$1'"
}

db_show() {
	if [ -z "$2" ]; then show_help; fi
	for x in "./$1/$2/"*; do
		echo "$x:" | sed "s/.*\///"
		cat "$x" | sed "s/^/    /"
		echo
	done

	printf "Tags: "
	ls "./$1/$2/.tag"
}

db_tag() {
	local db="$1" item="$2"
	shift
	shift
	for tag in $@; do
		mkdir "./$db/.tag/$tag"
		ln -s "$PWD/$db/$item" "./$db/.tag/$tag/"
		touch "./$db/$item/.tag/$tag"
	done
}

show_help() {
	echo "Usage: $0 command [args]"
	echo "Commands:"
	cat $0 | grep ") ##" | grep -v grep | sed 's/) ## /:\t/'
	exit
}

if [ -z "$1" ]; then show_help; fi

action=$1 it=database
shift
case $action in
	create) ## db -- create $it
		db_create "$@" ;;

	drop) ## db -- delete $it
		db_delete "$@" ;;

	add) ## db item -- add new item to $it
		mkdir -p "./$1/$2/.tag" && touch "./$1/$2/Description" ;;

	rem) ## db item -- delete item from $it
		rm -r "./$1/$2"
		rm "./$1/.tag/"*"/$2"
		;;

	show) ## db item -- show item
		db_show "$@" ;;

	newtag) ## db new-tag-name -- create new tag name
		mkdir "./$1/.tag/$2" ;;

	prop) ## db item property-name property-content -- add property to item
		echo "$4" > "./$1/$2/$3" ;;

	tag) ## db item tag [more-tags...] -- mark item with tags
		db_tag "$@" ;;

	last) ## db -- show latest item
		ls "$1" --sort=time | tail -n 1
		;;

	list) ## db -- list all items
		ls "$1" -1 --sort=time
		;;

	last-all) ## db -- list items in each category
		for x in "$1/.tag/"*; do
			echo "$x" | sed 's/.*\//Tag: /'
			printf "    "
			ls "$x" --sort=time | tail -n 1
			echo
		done
		;;

	help) ## this message
		show_help
		;;

	*)	echo Bad DB command: $1
		show_help
		;;
esac
