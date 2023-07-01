extends MainLoop


func _process(_delta: float) -> bool:
	var string: String = "123"
	string += "abc"
	print(string)
	return true # Exit
