extends MainLoop

func _process(_delta: float) -> bool:
	print("SPAM")
	return false # _process loops until true is returned
