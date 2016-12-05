shared void run2() {
	
	function intConcatenationComparer(Integer x, Integer y) {
		assert(exists xy = parseInteger(x.string + y.string),
			exists yx = parseInteger(y.string + x.string));
		return yx <=> xy;
	}
	
	function biggestConcatenation(Integer* ints) => "".join(ints.sort(intConcatenationComparer));
	
	value test1 = {1, 34, 3, 98, 9, 76, 45, 4};
	value test2 = {54, 546, 548, 60};
	
	print("``biggestConcatenation(*test1)`` and ``biggestConcatenation(*test2)``");
}
