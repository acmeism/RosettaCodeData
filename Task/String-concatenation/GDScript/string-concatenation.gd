extends MainLoop


func _process(_delta: float) -> bool:
	var first: String = "123"
	var second: String = first + "abc"

	print(first)
	print(second)

	return true # Exit
