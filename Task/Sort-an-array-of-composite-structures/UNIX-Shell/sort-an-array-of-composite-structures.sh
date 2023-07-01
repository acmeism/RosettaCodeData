list="namez:order!
name space:in
name1:sort
name:Please"

newline="
"

dumplist() {
	(
		IFS=$newline
		for pair in $list; do
			(
				IFS=:
				set -- $pair
				echo "  $1 => $2"
			)
		done
	)
}

echo "Original list:"
dumplist

list=`IFS=$newline; printf %s "$list" | sort -t: -k1,1`

echo "Sorted list:"
dumplist
