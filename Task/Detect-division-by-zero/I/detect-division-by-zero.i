function isdivbyzero(a, b) {
	var c = a/b
	if (c = 0) and (a != 0) or (a = 0) and (c >= 0)
		print( a, "/", b, " is a division by zero.")
		return
	end
	print( a, "/", b, " is not division by zero.")
}

software {
	isdivbyzero(5, 0)
	isdivbyzero(5, 2)
	isdivbyzero(0, 0)
}
