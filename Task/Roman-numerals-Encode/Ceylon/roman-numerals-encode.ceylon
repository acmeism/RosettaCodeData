shared void run() {
	
	class Numeral(shared Character char, shared Integer int) {}
	
	value tiers = [
		[Numeral('I', 1), Numeral('V', 5), Numeral('X', 10)],
		[Numeral('X', 10), Numeral('L', 50), Numeral('C', 100)],
		[Numeral('C', 100), Numeral('D', 500), Numeral('M', 1k)]
	];


	String toRoman(Integer hindu, Integer power = 2) {
		assert(exists tier = tiers[power]);
		if(hindu <= 0) {
			return "";
		} else if(exists num = tier.rest.find((Numeral elem) => elem.int - tier.first.int <= hindu < elem.int)) {
			return "``tier.first.char````num.char````toRoman(hindu - (num.int - tier.first.int), power)``";
		} else if(exists num = tier.reversed.find((Numeral elem) => hindu >= elem.int)) {
			return "``num.char````toRoman(hindu - num.int, power)``";
		} else {
			return toRoman(hindu, power - 1);
		}
	}
	
	assert(toRoman(1) == "I");
	assert(toRoman(2) == "II");
	assert(toRoman(4) == "IV");
	assert(toRoman(1666) == "MDCLXVI");
	assert(toRoman(1990) == "MCMXC");
	assert(toRoman(2008) == "MMVIII");
}
