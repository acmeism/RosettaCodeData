# Outputs a hailstone sequence from !:1, with one element per line.
# Clobbers $n.
alias hailstone eval \''@ n = \!:1:q		\\
	echo $n					\\
	while ( $n != 1 )			\\
		if ( $n % 2 ) then		\\
			@ n = 3 * $n + 1	\\
		else				\\
			@ n /= 2		\\
		endif				\\
		echo $n				\\
	end					\\
'\'

set sequence=(`hailstone 27`)
echo "Hailstone sequence from 27 has $#sequence elements:"
@ i = $#sequence - 3
echo "  $sequence[1-4] ... $sequence[$i-]"

# hailstone-length $i
#   acts like
# @ len = `hailstone $i | wc -l | tr -d ' '`
#   but without forking any subshells.
alias hailstone-length eval \''@ n = \!:1:q	\\
	@ len = 1				\\
	while ( $n != 1 )			\\
		if ( $n % 2 ) then		\\
			@ n = 3 * $n + 1	\\
		else				\\
			@ n /= 2		\\
		endif				\\
		@ len += 1			\\
	end					\\
'\'

@ i = 1
@ max = 0
@ maxlen = 0
while ($i < 100000)
	# XXX - I must run hailstone-length in a subshell, because my
	# C Shell has a bug when it runs hailstone-length inside this
	# while ($i < 1000) loop: it forgets about this loop, and
	# reports an error <<end: Not in while/foreach.>>
	@ len = `hailstone-length $i; echo $len`
	if ($len > $maxlen) then
		@ max = $i
		@ maxlen = $len
	endif
	@ i += 1
end
echo "Hailstone sequence from $max has $maxlen elements."
