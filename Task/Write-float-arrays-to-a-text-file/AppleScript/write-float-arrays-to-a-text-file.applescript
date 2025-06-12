property numString : ""

set x to {1, 2, 3, 1.0E+11}
set y to {1, 1.414213562373, 1.732050807569, 3.16227766016838E+5}

set xprecision to 3
set yprecision to 5
repeat with i from 1 to count x
	set numString to (numString & getNumPrecision(item i of x, xprecision) as text) & "    "
	set numString to (numString & getNumPrecision(item i of y, yprecision) as text) & linefeed
end repeat
set cfile to ((path to desktop folder) as text) & "filename.txt"
try
	set cfile to open for access file cfile with write permission
on error
	return
end try
set eof cfile to 0
write numString to cfile as text
close access cfile

on getNumPrecision(n, p)
	local b, g
	set b to log10(n)
	set g to p - b
	if g < 0 then
		repeat with i from g to -1 by 1
			set n to n / 10
		end repeat
		set n to n as integer
		repeat with i from g to -1 by 1
			set n to n * 10
		end repeat
	else if g > 0 then
		repeat with i from g to 1 by -1
			set n to n * 10
		end repeat
		set n to n as integer
		repeat with i from g to 1 by -1
			set n to n / 10
		end repeat
	else if g = 0 then
		set n to n as integer
	end if
	if (b < p) and (n = (n div 1)) then
		return n as double integer
	else
		return n as real
	end if
end getNumPrecision

on log10(n)
	local lg
	set lg to 1
	repeat until n < 10
		set n to n / 10
		set lg to lg + 1
	end repeat
	return lg
end log10
