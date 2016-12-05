shared void run() {
	
	value numerals = map {
		'I' -> 1,
		'V' -> 5,
		'X' -> 10,
		'L' -> 50,
		'C' -> 100,
		'D' -> 500,
		'M' -> 1000
	};
	
	function toHindu(String roman) {
		variable value total = 0;
		for(i->c in roman.indexed) {
			assert(exists currentValue = numerals[c]);
			/* Look at the next letter to see if we're looking
			 at a IV or CM or whatever. If so subtract the
			 current number from the total. */
			if(exists next = roman[i + 1],
				exists nextValue = numerals[next],
				currentValue < nextValue) {
				total -= currentValue;
			} else {
				total += currentValue;
			}
		}
		return total;
	}
	
	assert(toHindu("I") == 1);
	assert(toHindu("II") == 2);
	assert(toHindu("IV") == 4);
	assert(toHindu("MDCLXVI") == 1666);
	assert(toHindu("MCMXC") == 1990);
	assert(toHindu("MMVIII") == 2008);
}
