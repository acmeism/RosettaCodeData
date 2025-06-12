set outPutString to ""
set outPutString to outPutString & nthRoot2(34, 5) & linefeed
set outPutString to outPutString & nthRoot2(42, 10) & linefeed
set outPutString to outPutString & nthRoot2(5, 2) & linefeed

on nthRoot(x, n)
	local n1, y, res, abs
	set n1 to n - 1
	set res to x / n
	set abs to x
	repeat until abs < 1.0E-14
		set y to res
		set res to ((n1 * y) + (x / (y ^ n1))) / n
		if res > y then
			set abs to res - y
		else
			set abs to y - res
		end if
	end repeat
	set y to res div 1
	if res = y then return y
	return res
end nthRoot
