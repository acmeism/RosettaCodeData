shared void run() {
	
	class Numeral(shared Character char, shared Integer int) {}
	
	value tiers = [
		[Numeral('I', 1),   Numeral('V', 5),   Numeral('X', 10)],
		[Numeral('X', 10),  Numeral('L', 50),  Numeral('C', 100)],
		[Numeral('C', 100), Numeral('D', 500), Numeral('M', 1k)]
	];
	
	String toRoman(Integer hindu, Integer tierIndex = 2) {
		
		assert (exists tier = tiers[tierIndex]);
		
		" Finds if it's a two character numeral like iv, ix, xl, xc, cd and cm."
		function findTwoCharacterNumeral() =>
			if (exists bigNum = tier.rest.find((numeral) => numeral.int - tier.first.int <= hindu < numeral.int))
			then [tier.first, bigNum]
			else null;
		
		if (hindu <= 0) {
			// if it's zero then we are done!
			return "";
		}
		else if (exists [smallNum, bigNum] = findTwoCharacterNumeral()) {
			value twoCharSymbol = "``smallNum.char````bigNum.char``";
			value twoCharValue = bigNum.int - smallNum.int;
			return "``twoCharSymbol````toRoman(hindu - twoCharValue, tierIndex)``";
		}
		else if (exists num = tier.reversed.find((Numeral elem) => hindu >= elem.int)) {
			return "``num.char````toRoman(hindu - num.int, tierIndex)``";
		}
		else {
			// nothing was found so move to the next smaller tier!
			return toRoman(hindu, tierIndex - 1);
		}
	}
	
	assert (toRoman(1) == "I");
	assert (toRoman(2) == "II");
	assert (toRoman(4) == "IV");
	assert (toRoman(1666) == "MDCLXVI");
	assert (toRoman(1990) == "MCMXC");
	assert (toRoman(2008) == "MMVIII");
}
