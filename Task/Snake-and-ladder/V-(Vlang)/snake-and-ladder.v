import rand

const
(
	snl = {4: 14, 9: 31, 17: 7, 20: 38, 28: 84, 40: 59, 51: 67, 54: 34,
	62: 19, 63: 81, 64: 60, 71: 91, 87: 24, 93: 73, 95: 75, 99: 78}
)

fn main() {
	// three players starting on square one
	mut players := [1,1,1]
	mut ns := 0
	for {
		for i, s in players {
			ns = turn(i + 1, s)
			if ns == 100 {
				println("Player ${i+1} wins!")
				exit(0)
			}
			players[i] = ns
			println('')
		}
	}
}

fn turn(player int, square int) int {
	mut square2 := square
	mut roll, mut next := 0, 0
	for {
		roll = rand.int_in_range(1, 7) or {println('Error: invalid number') exit(1)}
		print("Player $player, on square $square2, rolls a $roll")
		if square2 + roll > 100 {println(" but cannot move.")}
		else {
			square2 += roll
			println(" and moves to square ${square2}.")
			if square2 == 100 {return 100}
			next = snl[square2]
			if next!= 0 {next = snl[square2]}
			else {next = square2}
			if square2 < next {
				println("Yay! Landed on a ladder. Climb up to ${next}.")
				if next == 100 {return 100}
				square2 = next
			}
			if square2 > next {
				println("Oops! Landed on a snake. Slither down to ${next}.")
				square2 = next
			}
		}
		if roll < 6 {return square2}
		println("Rolled a 6 so roll again. \n")
	}
	return next
}
