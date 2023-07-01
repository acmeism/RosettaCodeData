software {
	s = ""

	// Can either compare the string to an empty string or
	// test if the length is zero.
	if s = "" or #s = 0
		print("Empty string!")
	end

	if s - "" or #s - 0
		print("Not an empty string!")
	end
}
