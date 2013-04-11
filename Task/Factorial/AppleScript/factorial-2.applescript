on factorial(x)
	if x < 0 then return 0
	if x > 1 then return x * (my factorial(x - 1))
	return 1
end factorial
