local(x = 0)
while(#x != 10) => {^
	#x = integer_random(19,0)
	#x
	#x == 10 ? loop_abort
	', '+integer_random(19,0)+'\r'
^}
