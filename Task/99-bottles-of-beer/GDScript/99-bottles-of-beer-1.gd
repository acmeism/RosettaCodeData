extends MainLoop

# Represents a count of bottles
class Bottles:
	var count := 99

	func take(n: int = 1) -> void:
		count -= n

	func _to_string() -> String:
		match count:
			0: return "No more bottles"
			1: return "1 bottle"
			_: return "%s bottles" % count

func _process(_delta: float) -> bool:
	var bottles := Bottles.new()
	while bottles.count > 0:
		print("%s of beer on the wall" % bottles)
		print("%s of beer" % bottles)
		print("Take one down, pass it around")
		bottles.take()
		print("%s of beer on the wall" % bottles)
		# Seperate paragraphs
		if bottles.count > 0:
			print()

	return true # Makes the program exit
