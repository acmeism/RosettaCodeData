extends MainLoop

func _process(_delta: float) -> bool:
	printraw("Input a string: ")
	var read_line := OS.read_string_from_stdin() # Mote that this retains the newline.

	printraw("Input an integer: ")
	var read_integer := int(OS.read_string_from_stdin())

	print("read_line = %s" % read_line.trim_suffix("\n"))
	print("read_integer = %d" % read_integer)

	return true # Exit instead of looping
