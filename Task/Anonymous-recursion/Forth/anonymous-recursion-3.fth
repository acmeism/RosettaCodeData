: fib ( +n -- )
	dup 0< abort" Negative numbers don't exist"
	[: dup 2 < ?exit  1- dup MYSELF swap 1- MYSELF + ;] execute . ;
