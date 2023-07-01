shared void run() {
	
	function notAdjacent(Integer a, Integer b) => (a - b).magnitude >= 2;
	function allDifferent(Integer* ints) => ints.distinct.size == ints.size;
	
	value solutions = [
		for (baker in 1..4)
		for (cooper in 2..5)
		for (fletcher in 2..4)
		for (miller in 2..5)
		for (smith in 1..5)
		if (miller > cooper &&
			notAdjacent(smith, fletcher) &&
			notAdjacent(fletcher, cooper) &&
			allDifferent(baker, cooper, fletcher, miller, smith))
		"baker lives on ``baker``
		 cooper lives on ``cooper``
		 fletcher lives on ``fletcher``
		 miller lives on ``miller``
		 smith lives on ``smith``"
	];
	
	print(solutions.first else "No solution!");
}
