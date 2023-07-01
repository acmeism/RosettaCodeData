shared void freeCellDeal() {

	//a function that returns a random number generating function
	function createRNG(variable Integer state) =>
			() => (state = (214_013 * state + 2_531_011) % 2^31) / 2^16;
	
	void deal(Integer num) {
		// create an array with a list comprehension
		variable value deck = Array {
			for(rank in "A23456789TJQK")
			for(suit in "CDHS")
			"``rank````suit``"
		};
		value rng = createRNG(num);
		for(i in 1..52) {
			value index = rng() % deck.size;
			assert(exists lastIndex = deck.lastIndex);
			//swap the random card with the last one
			deck.swap(index, lastIndex);
			//print the last one
			process.write("``deck.last else "missing card"`` " );
			if(i % 8 == 0) {
				print("");
			}
			//and shrink the array to remove the last card
			deck = deck[...lastIndex - 1];
		}
	}
	
	deal(1);
	print("\n");
	deal(617);
}
