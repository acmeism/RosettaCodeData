shared void run() {
	
	function digitsSquaredSum(variable Integer n) {
		variable value total = 0;
		while(n > 0) {
			total += (n % 10) ^ 2;
			n /= 10;
		}
		return total;
	}
	
	function lastSum(variable Integer n) {
		while(true) {
			n = digitsSquaredSum(n);
			if(n == 89 || n == 1) {
				return n;
			}
		}
	}
	
	variable value eightyNines = 0;
	for(i in 1..100M - 1) {
		if(lastSum(i) == 89) {
			eightyNines++;
		}
	}
	print(eightyNines);
}
