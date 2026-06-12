public final class CubicSpecialPrimes {

	public static void main(String[] args) {
		int p = 2;
		int n = 1;
		System.out.print(2 + " ");

		while ( p + n * n * n < 15_000 ) {
		    if ( isPrime(p + n * n * n) ) {
		        p += n * n * n;
		        n = 1;
		        System.out.print(p + " ");
		    } else {
		        n += 1;
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
