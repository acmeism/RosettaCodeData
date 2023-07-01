extends MainLoop


enum Strategy {Random, Optimal}

const prisoner_count := 100


func get_random_drawers() -> Array[int]:
	var drawers: Array[int] = []
	drawers.resize(prisoner_count)
	for i in range(0, prisoner_count):
		drawers[i] = i + 1
	drawers.shuffle()
	return drawers


var random_strategy = func(drawers: Array[int], prisoner: int) -> bool:
	# Randomly selecting 50 drawers is equivalent to shuffling and picking the first 50
	var drawerCopy: Array[int] = drawers.duplicate()
	drawerCopy.shuffle()
	for i in range(50):
		if drawers[drawerCopy[i]-1] == prisoner:
			return true
	return false


var optimal_strategy = func(drawers: Array[int], prisoner: int) -> bool:
	var choice: int = prisoner
	for _i in range(50):
		var drawer_value: int = drawers[choice-1]
		if drawer_value == prisoner:
			return true
		choice = drawer_value
	return false


func play_all(drawers: Array[int], strategy: Callable) -> bool:
	for prisoner in range(1, prisoner_count+1):
		if not strategy.call(drawers, prisoner):
			return false
	return true


func _process(_delta: float) -> bool:
	# Constant seed for reproducibility, call randomize() in real use
	seed(1234)

	const SAMPLE_SIZE: int = 10_000

	var random_successes: int = 0
	for i in range(SAMPLE_SIZE):
		if play_all(get_random_drawers(), random_strategy):
			random_successes += 1

	var optimal_successes: int = 0
	for i in range(SAMPLE_SIZE):
		if play_all(get_random_drawers(), optimal_strategy):
			optimal_successes += 1

	print("Random play: %%%f" % (100.0 * random_successes/SAMPLE_SIZE))
	print("Optimal play: %%%f" % (100.0 * optimal_successes/SAMPLE_SIZE))

	return true # Exit
