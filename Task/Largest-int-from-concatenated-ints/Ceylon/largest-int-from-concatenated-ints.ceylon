shared void run() {
	
	function comparator(Integer x, Integer y) {
		assert (is Integer xy = Integer.parse(x.string + y.string),
			is Integer yx = Integer.parse(y.string + x.string));
		return yx <=> xy;
	}
	
	function biggestConcatenation({Integer*} ints) => "".join(ints.sort(comparator));
	
	value test1 = {1, 34, 3, 98, 9, 76, 45, 4};
	print(biggestConcatenation(test1));
	
	value test2 = {54, 546, 548, 60};
	print(biggestConcatenation(test2));
}
