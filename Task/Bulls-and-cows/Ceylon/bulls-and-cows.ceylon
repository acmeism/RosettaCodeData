import ceylon.random {

	DefaultRandom
}

shared void run() {
	
	value random = DefaultRandom();
	
	function generateDigits() =>
			random.elements(1..9).distinct.take(4).sequence();
	
	function validate(String guess) {
		variable value ok = true;
		if(!guess.every((Character element) => element.digit)) {
			print("numbers only, please");
			ok = false;
		}
		if('0' in guess) {
			print("only 1 to 9, please");
			ok = false;
		}
		if(guess.distinct.shorterThan(guess.size)) {
			print("no duplicates, please");
			ok = false;
		}
		if(guess.size != 4) {
			print("4 digits please");
			ok = false;
		}
		return ok;
	}

	function score({Integer*} target, {Integer*} guess) {
		variable value bulls = 0;
		variable value cows = 0;
		for([a, b] in zipPairs(target, guess)) {
			if(a == b) {
				bulls++;
			} else if(target.contains(b)) {
				cows++;
			}
		}
		return [bulls, cows];
	}
	
	while(true) {
		value digits = generateDigits();
		print("I have chosen my four digits, please guess what they are.
		       Use only the digits 1 to 9 with no duplicates and enter them with no spaces. eg 1234
		       Enter q or Q to quit.");
		while(true) {
			if(exists line = process.readLine()) {
				if(line.uppercased == "Q") {
					return;
				}
				if(validate(line)) {
					value guessDigits = line.map((Character element) => parseInteger(element.string)).coalesced;
					value [bulls, cows] = score(digits, guessDigits);
					if(bulls == 4) {
						print("You win!");
						break;
					} else {
						print("Bulls: ``bulls``, Cows:  ``cows``");
					}
				}
			}
		}
	}
}
