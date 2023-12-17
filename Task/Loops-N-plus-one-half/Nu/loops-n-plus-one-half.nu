for i in 1.. {
	print -n $i
	if $i == 10 {
		print ""
		break
	}
	print -n ", "
}
