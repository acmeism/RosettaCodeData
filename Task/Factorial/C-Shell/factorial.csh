alias factorial eval \''set factorial_args=( \!*:q )	\\
	@ factorial_n = $factorial_args[2]		\\
	@ factorial_i = 1				\\
	while ( $factorial_n >= 2 )			\\
		@ factorial_i *= $factorial_n		\\
		@ factorial_n -= 1			\\
	end						\\
	@ $factorial_args[1] = $factorial_i		\\
'\'

factorial f 12
echo $f
# => 479001600
