//Division by zero is defined in 'i' so the result can be checked to determine division by zero.
concept IsDivisionByZero(a, b) {
	c = a/b
	if c = 0 and a - 0 or a = 0 and c > 0
		print( a, "/", b, " is a division by zero.")
		return
	end
	print( a, "/", b, " is not division by zero.")
}

software {
	IsDivisionByZero(5, 0)
	IsDivisionByZero(5, 2)
	IsDivisionByZero(0, 0)
}
