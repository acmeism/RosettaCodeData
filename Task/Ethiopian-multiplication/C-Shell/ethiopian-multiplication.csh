alias halve '@ \!:1 /= 2'
alias double '@ \!:1 *= 2'
alias is_even '@ \!:1 = ! ( \!:2 % 2 )'

alias multiply eval \''set multiply_args=( \!*:q )		\\
	@ multiply_plier = $multiply_args[2]			\\
	@ multiply_plicand = $multiply_args[3]			\\
	@ multiply_result = 0					\\
	while ( $multiply_plier > 0 )				\\
		is_even multiply_is_even $multiply_plier	\\
		if ( ! $multiply_is_even ) then			\\
			@ multiply_result += $multiply_plicand	\\
		endif						\\
		halve multiply_plier				\\
		double multiply_plicand				\\
	end							\\
	@ $multiply_args[1] = $multiply_result			\\
'\'

multiply p 17 34
echo $p
# => 578
