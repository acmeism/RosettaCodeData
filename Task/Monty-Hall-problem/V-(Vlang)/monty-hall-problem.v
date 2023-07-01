import rand

fn main() {
	games := 1_000_000
	mut doors := [3]int{}
	mut switch_wins, mut stay_wins, mut shown, mut guess := 0, 0, 0, 0
	for _ in 1..games + 1 {
		doors[rand.int_in_range(0, 3) or {exit(1)}] = 1 // Set which one has the car
		guess = rand.int_in_range(0, 3) or {exit(1)} // Choose a door
        for doors[shown] == 1 || shown == guess {
            shown = rand.int_in_range(0, 3) or {exit(1)} // Shown door
        }
        stay_wins += doors[guess]
        switch_wins += doors[3 - guess - shown]
		for clear in 0..3 {if doors[clear] != 0 {doors[clear] = 0}}
	}
	println("Simulating ${games} games:")
	println("Staying wins ${stay_wins} times at ${(f32(stay_wins) / f32(games) * 100):.2}% of games")
	println("Switching wins ${switch_wins} times at ${(f32(switch_wins) / f32(games) * 100):.2}% of games")
}
