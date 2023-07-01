shared void run() {
	
	function divisors(Integer int) =>
			if(int <= 1)
			then {}
			else (1..int / 2).filter((Integer element) => element.divides(int));
	
	for(i in 1..10) {
		print("``i`` => ``divisors(i)``");
	}
	
	value start = 1;
	value end = 20k;
	
	value mostDivisors =
			map {for(i in start..end) i->divisors(i).size}
			.inverse()
			.max(byKey(byIncreasing(Integer.magnitude)));
	
	print("the number(s) with the most divisors between ``start`` and ``end`` is/are:
	       ``mostDivisors?.item else "nothing"`` with ``mostDivisors?.key else "no"`` divisors");
}
