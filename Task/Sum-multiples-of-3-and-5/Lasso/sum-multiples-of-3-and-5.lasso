local(limit = 1)
while(#limit <= 100000) => {^
	local(s = 0)
	loop(-from=3,-to=#limit-1) => {
		not (loop_count % 3) || not (loop_count % 5) ? #s += loop_count
	}
	'The sum of multiples of 3 or 5 between 1 and '+(#limit-1)+' is: '+#s+'\r'
	#limit = integer(#limit->asString + '0')
^}
