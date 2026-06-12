set i to 1
set n to 1
repeat while n < 1000
	if n > 100 then log n
	set n to n + 8 * i
	set i to i + 1
end repeat
