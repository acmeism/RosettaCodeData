on montecarlo(n)
	set m to 0
	repeat n times
		set x to random number from 0.0 to 1.0
		set y to random number from 0.0 to 1.0
		if x ^ 2 + y ^ 2 < 1 then set m to m + 1
	end repeat
	return 4 * m / n
end montecarlo

montecarlo(1000000)
