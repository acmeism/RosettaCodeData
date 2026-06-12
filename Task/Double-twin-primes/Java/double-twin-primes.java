public final class DoubleTwinPrimes {

	public static void main(String[] args) {
		System.out.println("Double twin primes under 1,000:");
		for ( int n = 3; n <= 991; n += 2 ) {
		    if ( isPrime(n) && isPrime(n + 2) && isPrime(n + 6) && isPrime(n + 8) ) {
		        System.out.println("[" + n + ", " + ( n + 2 ) + ", " + ( n + 6 ) + ", " + ( n + 8 ) + "]");
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
