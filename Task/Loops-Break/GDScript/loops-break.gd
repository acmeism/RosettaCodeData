extends MainLoop


func _process(_delta: float) -> bool:
	randomize()

	while true:
		var a: int = randi_range(0, 19)
		print(a)
		if a == 10:
			break
		var b: int = randi_range(0, 19)
		print(b)

	return true # Exit
