text_between() {
	local search="${1:?Search text not provided}"
	local start_str="${2:?Start text not provided}"
	local end_str="${3:?End text not provided}"
	local temp=

	if [ "$start_str" != "start" ]; then
		# $temp will be $search with everything before the first occurrence of
		# $start_str (inclusive) removed, searching from the beginning.
		temp="${search#*$start_str}"
		# If the start delimiter wasn't found, return an empty string.
		# Comparing length rather than string equality because character
		# comparison is not necessary here.
		if [ "${#temp}" -eq "${#search}" ]; then
			search=
		else
			search="$temp"
		fi
	fi

	if [ "$end_str" = "end" ]; then
		echo "$search"
	else
		# Output will be $search with everything after the last occurrence of
		# $end_str (inclusive) removed, searching from the end.
		echo "${search%%$end_str*}"
	fi
	return 0
}

text_between "Hello Rosetta Code world" "Hello " " world"
text_between "Hello Rosetta Code world" "start" " world"
text_between "Hello Rosetta Code world" "Hello " "end"
