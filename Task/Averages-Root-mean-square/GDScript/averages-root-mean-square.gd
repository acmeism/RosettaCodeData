extends Node


func root_mean_square(data: Array[float]) -> float:
	if data.is_empty():
		return 0.0

	var sum_of_squares := 0.0
	for x in data:
		sum_of_squares += x * x

	return sqrt(sum_of_squares / data.size())


func _ready() -> void:
	print(root_mean_square([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]))
	get_tree().quit()
