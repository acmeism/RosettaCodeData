public final class ProductOfMinAndMaxPrimeFactors {

	public static void main(String[] args) {
		System.out.println("The product of smallest and greatest prime factors of numbers from 1 to 100:");
		for ( int n = 1; n <= 100; n++ ) {
			final int product = productMinMaxPrimeFactors(n);
			System.out.print(String.format("%4d%s", product, ( n % 10 == 0 ) ? "\n" : " " ));
		}
	}
	
	private static int productMinMaxPrimeFactors(int n) {
	    int minPrimeFactor = 1;
	    int maxPrimeFactor = 1;
	
	    if ( n % 2 == 0 ) {
	        while ( n % 2 == 0 ) {
	            n >>= 1;
	        }
	        minPrimeFactor = 2;
	        maxPrimeFactor = 2;
	    }
	
	    for ( int p = 3; p * p <= n; p += 2 ) {
	        if ( n % p == 0 ) {
	            while ( n % p == 0 ) {
	                n /= p;
	            }
	            if ( minPrimeFactor == 1 ) {
	                minPrimeFactor = p;
	            }
	            maxPrimeFactor = p;
	        }
	    }
	
	    if ( n > 1 ) {
	        if ( minPrimeFactor == 1 ) {
	            minPrimeFactor = n;
	        }
	        maxPrimeFactor = n;
	    }
	
	    return minPrimeFactor * maxPrimeFactor;
	}

}
