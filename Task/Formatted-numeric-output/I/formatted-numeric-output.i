concept FixedLengthFormat(value, length) {
	string = text(abs(value))
	prefix = ""
	sign = ""
	
	if value < 0
		sign = "-"
	end
	
	if #string < length
		prefix = "0"*(length-#sign-#string-#prefix)
	end
	
	return sign+prefix+string
}

software {
	d = 7.125
	print(FixedLengthFormat(d, 9))
	print(FixedLengthFormat(-d, 9))
}
