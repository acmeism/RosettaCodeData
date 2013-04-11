gcd() {
	# Calculate $1 % $2 until $2 becomes zero.
	until test 0 -eq "$2"; do
		# Parallel assignment: set -- 1 2
		set -- "$2" "`expr "$1" % "$2"`"
	done

	# Echo absolute value of $1.
	test 0 -gt "$1" && set -- "`expr 0 - "$1"`"
	echo "$1"
}

lcm() {
	set -- "$1" "$2" "`gcd "$1" "$2"`"
	set -- "`expr "$1" \* "$2" / "$3"`"
	test 0 -gt "$1" && set -- "`expr 0 - "$1"`"
	echo "$1"
}

lcm 30 -42
# => 210
