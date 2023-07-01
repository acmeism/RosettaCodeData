# First 30 positive integers which are squares but not cubes
# also, the first 3 positive integers which are both squares and cubes

 ######
# main #
 ######

integer n sq cr cnt=0

for (( n=1; cnt<30; n++ )); do
	(( sq = n * n ))
	(( cr = cbrt(sq) ))
	if (( (cr * cr * cr) != sq )); then
		(( cnt++ ))
		print ${sq}
	else
		print "${sq} is square and cube"
	fi
done
