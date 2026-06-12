public final class SumOfPrimesInOddPositionsIsPrime {

	public static void main(String[] args) {
		System.out.println("  i  p(i)  sum");
		System.out.println("---------------");
		int index = 0;
		int sum = 0;
		int p = 1;
		
		while ( p < 1_000 ) {
		    p += 1;
		    if ( isPrime(p) ) {
		    	index += 1;
		    	if ( index % 2 == 1 ) {
		    		sum += p;
		    		if ( isPrime(sum) ) {
		    			System.out.println(String.format("%3d%5d%7d", index, p, sum));
		    		}
		    	}
		    }
		}
	}
	
	private static boolean isPrime(int number) {
	    if ( number % 2 == 0 ) {
	    	return number == 2;
	    }
	
	    int k = 3;
	    while ( k * k <= number ) {
	    	if ( number % k == 0 ) {
	    		return false;
	    	}
	    	k += 2;
	    }
	    return true;
	}

}
