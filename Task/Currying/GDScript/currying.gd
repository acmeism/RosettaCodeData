extends Node

func addN(n: int) -> Callable:
	return func(x):
		return n + x

func _ready():
	# Test currying
	var add2 := addN(2)
	print(add2.call(7))

	get_tree().quit() # Exit
