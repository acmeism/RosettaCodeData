extends MainLoop


func _process(_delta: float) -> bool:
	while true:
		# Read a line from stdin
		var input: String = OS.read_string_from_stdin()

		# Empty lines are "\n" whereas end of input will be completely empty.
		if len(input) == 0:
			break
		printraw(input)
	return true # Exit
