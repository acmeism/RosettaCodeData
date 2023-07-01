shared void run() {

	value strings = [
		"Cat", "apple", "Adam", "zero", "Xmas", "quit",
		"Level", "add", "Actor", "base", "butter"
	];

	value sorted = strings.sort((String x, String y) =>
			if(x.size == y.size)
			then increasing(x.lowercased, y.lowercased)
			else decreasing(x.size, y.size));
	
	sorted.each(print);
}
