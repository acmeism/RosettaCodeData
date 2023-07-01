extends MainLoop


enum Player {Human, Computer}

const target: int = 21


# -1 is returned to request quit
func get_player_choice(total: int) -> int:
	while true:
		printraw("Player's choice: ")
		var input: String = OS.read_string_from_stdin().strip_edges()

		if input == "quit":
			return -1

		if not input.is_valid_int():
			print("Please input an integer.")
			continue

		var input_int := int(input)
		if input_int < 1 or input_int > 3:
			print("Please pick a number from 1 to 3")
			continue

		if input_int + total > target:
			print("Please do not exceed a total of %d" % target)
			continue

		return input_int

	# This is required since Godot does not detect the unreachable code path
	OS.crash("unreachable")
	return 0


func get_computer_choice(total: int) -> int:
	# This can be shortened using max() if you do not have type checking OCD
	var remaining: int = target - total
	return randi_range(1, 3 if remaining > 3 else remaining)


func play() -> void:
	print("""\
Welcome to the 21 game.
Type quit to exit.""")
	var total: int = 0
	var player: Player
	match randi_range(1, 2):
		1:
			player = Player.Human
			print("You will go first.")
		2:
			player = Player.Computer
			print("The computer will go first.")

	while true:
		print("\nThe total is %d" % total)

		var choice: int
		match player:
			Player.Human:
				choice = get_player_choice(total)
				if choice == -1:
					return
			Player.Computer:
				choice = get_computer_choice(total)
				print("The computer plays %d" % choice)
		assert(1 <= choice and choice <= 3)

		total += choice
		if total == target:
			match player:
				Player.Human: print("You win!")
				Player.Computer: print("The computer won, you lose.")
			return
		assert(total < target)

		match player:
			Player.Human: player = Player.Computer
			Player.Computer: player = Player.Human


func _process(_delta: float) -> bool:
	randomize()
	play()
	return true
