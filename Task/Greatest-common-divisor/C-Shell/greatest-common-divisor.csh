alias gcd eval \''set gcd_args=( \!*:q )	\\
	@ gcd_u=$gcd_args[2]			\\
	@ gcd_v=$gcd_args[3]			\\
	while ( $gcd_v != 0 )			\\
		@ gcd_t = $gcd_u % $gcd_v	\\
		@ gcd_u = $gcd_v		\\
		@ gcd_v = $gcd_t		\\
	end					\\
	if ( $gcd_u < 0 ) @ gcd_u = - $gcd_u	\\
	@ $gcd_args[1]=$gcd_u			\\
'\'

gcd result -47376 87843
echo $result
# => 987
