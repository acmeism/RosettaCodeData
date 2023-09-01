public final class LargestProperDivisor {

	public static void main(String[] aArgs) {
		for ( int n = 1; n < 101; n++ ) {
	        System.out.print(String.format("%2d%s", largestProperDivisor(n), ( n % 10 == 0 ? "\n" : " " )));
	    }
	}
	
	private static int largestProperDivisor(int aNumber) {
		if ( aNumber < 1 ) {
			throw new IllegalArgumentException("Argument must be >= 1: " + aNumber);
		}
	
	    if ( ( aNumber & 1 ) == 0 ) {
	        return aNumber >> 1;
	    }	
	    for ( int p = 3; p * p <= aNumber; p += 2 ) {
	        if ( aNumber % p == 0 ) {
	            return aNumber / p;
	        }
	    }	
	    return 1;
	}

}
