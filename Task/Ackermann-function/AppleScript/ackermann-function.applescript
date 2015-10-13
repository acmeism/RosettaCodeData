on ackermann(m, n)
	if m is equal to 0 then return n + 1
	if n is equal to 0 then return ackermann(m - 1, 1)
	return ackermann(m - 1, ackermann(m, n - 1))
end ackermann
