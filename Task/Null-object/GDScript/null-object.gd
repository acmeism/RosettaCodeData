extends Node2D

func _ready() -> void:
	var empty : Object
	var not_empty = Object.new()
	
	# Compare with null.
	if empty == null:
		print("empty is null")
	else:
		print("empty is not null")
	
	# C-like comparation.
	if not_empty:
		print("not_empty is not null")
	else:
		print("not_empty is null")
	return
