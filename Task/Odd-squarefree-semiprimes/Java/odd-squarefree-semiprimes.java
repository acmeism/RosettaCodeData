public final class OddSquareFreeSemiprimes {

	public static void main(String[] args) {		
		final int limit = 1_000;
	    System.out.println("Odd square-free semiprimes less than " + limit + ":");
	    int count = 0;
	    for ( int i = 1; i < limit; i += 2 ) {
	        if ( isSquarefreeSemiprime(i) ) {
	            count += 1;
	            System.out.print(String.format("%3d%s", i, ( count % 20 == 0 ? "\n" : " " )));
	        }
	    }
	}

	private static boolean isSquarefreeSemiprime(int n) {
	    int smallFactorCount = 0;
	    for ( int i = 3; i * i <= n; i += 2 ) {
	    	while ( n % i == 0 ) {
	    		if ( ++smallFactorCount > 1 ) {
	    			return false;
	    		}
	    		n /= i;
	    	}
	    }
	    return smallFactorCount == 1;
	}

}
