extends MainLoop

# Implementation of zip, same length as the shortest array
func zip(lists: Array[Array]) -> Array[Array]:
	var length: int = lists.map(func(arr): return len(arr)).reduce(func(a,b): return min(a,b))
	var result: Array[Array] = []
	result.resize(length)
	for i in length:
		result[i] = lists.map(func(arr): return arr[i])
	return result

func _process(_delta: float) -> bool:
	var a: Array[String] = ["a", "b", "c"]
	var b: Array[String] = ["A", "B", "C"]
	var c: Array[String] = ["1", "2", "3"]

	for column in zip([a,b,c]):
		print(''.join(column))
	return true # Exit
