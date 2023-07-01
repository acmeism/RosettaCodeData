set a=(a b c)
set b=(A B C)
set c=(1 2 3)
@ i = 1
while ( $i <= $#a )
	echo "$a[$i]$b[$i]$c[$i]"
	@ i += 1
end
