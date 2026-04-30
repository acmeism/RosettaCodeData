import rand

fn min(a int, b int) int {
	if a < b { return a }
	return b
}

fn main() {
	mut deck, mut discard := []string{}, []string{}	
	mut black_pile, mut red_pile := []string{}, []string{}
	mut red_bunch, mut black_bunch := []string{}, []string{}
	// create deck with 26 black and 26 red cards
	for _ in 0..26 {
		deck << "black"
		deck << "red"
	}
	rand.shuffle(mut deck) or {
		eprintln("Failed to shuffle deck")
		return
	}
	for deck.len > 0 {
		discard << deck.pop()
		if discard.last() == "black" {
			if deck.len > 0 { black_pile << deck.pop() }
		}
		else {
			if deck.len > 0 { red_pile << deck.pop() }
		}
	}
	// random number x between 0 and minimum pile size
	x := rand.intn(min(black_pile.len, red_pile.len) + 1)! // +1 to include min size
	// randomly remove x cards from each pile
	for _ in 0 .. x {
		red_index := rand.intn(red_pile.len)!
		red_bunch << red_pile[red_index]
		red_pile.delete(red_index)
		black_index := rand.intn(black_pile.len)!
		black_bunch << black_pile[black_index]
		black_pile.delete(black_index)
	}
	// swap bunches
	black_pile << red_bunch
	red_pile << black_bunch
	// count cards in different piles
	black_red_count := black_pile.filter(it == "red").len
	red_red_count := red_pile.filter(it == "red").len
	println("The magician predicts there will be $black_red_count red cards in the other pile.")
	println("Drumroll...")
	println("There were $red_red_count!")
}
