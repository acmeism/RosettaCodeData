public final class FindPrimeNumbersOfTheFormNCubedPlusTwo {

	public static void main(String[] args) {
		System.out.println(" n    n³ + 2");
		System.out.println("------------");
		for ( int n = 1; n < 200; n += 2 ) {
	        int p = n * n * n + 2;
	        if  ( isPrime(p) ) {
	            System.out.println(String.format("%-5d%d", n, p));
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
