map() {
	typeset command=$1
	shift
	for i do "$command" "$i"; done
}
set -A ary 1 2 3
map print "${ary[@]}"
