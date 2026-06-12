#!/usr/bin/env ijconsole

meaningOfLife =: 42

main =: monad define
	echo 'Main: The meaning of life is ',": meaningOfLife
	exit ''
)

shouldrun =: monad define
	if. 1 e. 'modulinos.ijs' E. ;ARGV do.
		main 0
	end.
)

shouldrun 0
