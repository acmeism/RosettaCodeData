map() {
	map_command=$1
	shift
	for i do "$map_command" "$i"; done
}
list=1:2:3
(IFS=:; map echo $list)
