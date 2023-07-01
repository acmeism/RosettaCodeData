shared void run() {
	{Integer*} getFactors(Integer n) =>
		(1..n).filter((Integer element) => element.divides(n));
	
	for(Integer i in 1..100) {
		print("the factors of ``i`` are ``getFactors(i)``");
	}
}
