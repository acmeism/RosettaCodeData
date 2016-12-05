shared void run() {
	
	Integer? recursiveFactorial(Integer n) =>
			switch(n <=> 0)
			case(smaller) null
			case(equal) 1
			case(larger) if(exists f = recursiveFactorial(n - 1)) then n * f else null;
	
	
	Integer? iterativeFactorial(Integer n) =>
			switch(n <=> 0)
			case(smaller) null
			case(equal) 1
			case(larger) (1:n).reduce(times);
	
	for(Integer i in 0..10) {
		print("the iterative factorial of     ``i`` is ``iterativeFactorial(i) else "negative"``
		       and the recursive factorial of ``i`` is ``recursiveFactorial(i) else "negative"``\n");
	}
}
