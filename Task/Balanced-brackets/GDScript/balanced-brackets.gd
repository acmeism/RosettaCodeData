extends MainLoop

func generate_brackets(n: int) -> String:
	var brackets: Array[String] = []

	# Add opening and closing brackets
	brackets.resize(2*n)
	for i in range(0, 2*n, 2):
		brackets[i] = "["
		brackets[i+1] = "]"

	brackets.shuffle()
	return "".join(brackets)

func is_balanced(str: String) -> bool:
	var unclosed_brackets := 0
	for c in str:
		match c:
			"[":
				unclosed_brackets += 1
			"]":
				if unclosed_brackets == 0:
					return false
				unclosed_brackets -= 1
			_:
				return false
	return unclosed_brackets == 0

func _process(_delta: float) -> bool:
	randomize()

	for i in range(6):
		var bracket_string := generate_brackets(i)

		if is_balanced(bracket_string):
			print("%sOK" % bracket_string.rpad(13))
		else:
			print("%sNOT OK" % bracket_string.rpad(11))

	return true # Exit
