on horner(x, coeffs)
	set accumulator to 0
	set n to length of coeffs
	repeat with i from n to 1 by -1
		set c to item i of coeffs
		set accumulator to (x * accumulator) + c
	end repeat
	return accumulator
end horner

horner(3, {-19, 7, -4, 6})
