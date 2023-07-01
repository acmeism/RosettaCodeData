shared void run() {

	function divisors(Integer int) =>
			if(int <= 1) then {} else (1..int / 2).filter((Integer element) => element.divides(int));
	
	function classify(Integer int) => sum {0, *divisors(int)} <=> int;
	
	value counts = (1..20k).map(classify).frequencies();
	
	print("deficient: ``counts[smaller] else "none"``");
	print("perfect:   ``counts[equal] else "none"``");
	print("abundant:  ``counts[larger] else "none"``");
}
