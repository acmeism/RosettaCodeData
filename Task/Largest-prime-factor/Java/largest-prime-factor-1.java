public final class LargestPrimeFactor {

	public static void main(String[] args) {
		System.out.println("The largest prime factor of 600851475143 is " + largestPrimeFactor(600851475143L));
	}

	private static long largestPrimeFactor(long number) {
	    if ( number < 2 ) {
	    	throw new AssertionError("Argument must be >= 2");
	    }
	
	    final int[] increments = new int[] { 4, 2, 4, 2, 4, 6, 2, 6 };
	    long largest = 1;
	    for ( int divisor : new int[] { 2, 3, 5 } ) {	
		    while ( number % divisor == 0 ) {
		        largest = divisor;
		        number /= divisor;
		    }
	    }
	
	    long k = 7;
	    int i = 0;
	    while ( k * k <= number ) {
	        if ( number % k == 0 ) {
	            largest = k;
	            number /= k;
	        } else {
	            k += increments[i];
	            i = ( i + 1 ) % 8;
	        }
	    }
	    return ( number > 1 ) ? number : largest;
	}

}
