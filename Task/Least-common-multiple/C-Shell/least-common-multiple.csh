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

alias lcm eval \''set lcm_args=( \!*:q )	\\
	@ lcm_m = $lcm_args[2]			\\
	@ lcm_n = $lcm_args[3]			\\
	gcd lcm_d $lcm_m $lcm_n			\\
	@ lcm_r = ( $lcm_m * $lcm_n ) / $lcm_d	\\
	if ( $lcm_r < 0 ) @ lcm_r = - $lcm_r	\\
	@ $lcm_args[1] = $lcm_r			\\
'\'

lcm result 30 -42
echo $result
# => 210
