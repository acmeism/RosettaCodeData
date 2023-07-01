extends MainLoop


func _process(_delta: float) -> bool:
	var string: String = "alphaBETA"
	print(string.to_upper())
	print(string.to_lower())

	# Note: These will also add/remove underscores.
	print("to_camel_case: ", string.to_camel_case())
	print("to_pascal_case: ", string.to_pascal_case())
	print("to_snake_case: ", string.to_snake_case())

	return true # Exit
