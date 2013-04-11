i = 99
s = s
while {test $i -gt 0} {
	echo $i bottle$s of beer on the wall
	echo $i bottle$s of beer
	echo Take one down, pass it around
	i = `{expr $i - 1}
	if {test $i -eq 1} {s = ''} {s = s}
	echo $i bottle$s of beer on the wall
	echo
}
