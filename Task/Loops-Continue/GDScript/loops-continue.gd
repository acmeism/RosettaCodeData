extends MainLoop


func _process(_delta: float) -> bool:
	for i in range(1,11):
		if i % 5 == 0:
			print(i)
			continue
		printraw(i, ", ")

	return true # Exit
