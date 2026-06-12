set n to 6.00851475143E+11
"The largest prime factor of " & n & " is " & gpf(n)

on gpf(n) -- greatest prime factor
	local j, nj, sq
	set j to 2
	set nj to n / j
	set gpf to 0
	repeat while (nj div 1) = nj -- remove Evens
		set n to nj div 1
		set nj to n / j
	end repeat
	if n = 1 then return j
	set sq to (n ^ 0.5) div 1 -- integer square-root
	set j to 3
	repeat until j > sq
		set nj to n / j
		set flag to true
		repeat while (nj div 1) = nj
			set n to nj div 1
			set nj to n / j
			if flag then set flag to false
		end repeat
		if n = 1 then return j
		if flag = false then set sq to (n ^ 0.5) div 1 -- integer square-root
		set j to j + 2
	end repeat
	return n
end gpf
