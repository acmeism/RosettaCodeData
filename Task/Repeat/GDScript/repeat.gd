extends Node

func repeat(f: Callable, n: int) -> void:
	for _i in range(n):
		f.call()

func _ready() -> void:
	repeat(func() -> void: print("Hello"), 3)
	get_tree().quit()

