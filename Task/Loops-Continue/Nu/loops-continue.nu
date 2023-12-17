for i in 1..10 {
	print -n $i
	if $i mod 5 == 0 {
		print ""
		continue
	}
	print -n ", "
}
