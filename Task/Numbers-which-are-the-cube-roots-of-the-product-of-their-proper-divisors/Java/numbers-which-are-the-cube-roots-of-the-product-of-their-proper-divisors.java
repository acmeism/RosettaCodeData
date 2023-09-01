public final class NumbersCubeRootProductProperDivisors {

	public static void main(String[] aArgs) {
		System.out.println("The first 50 numbers which are the cube roots"
			+ " of the products of their proper divisors:");
		for ( int n = 1, count = 0; count < 50_000; n++ ) {
			if ( n == 1 || divisorCount(n) == 8 ) {
			   count += 1;
			   if ( count <= 50 ) {
				   System.out.print(String.format("%4d%s", n, ( count % 10 == 0 ? "\n" : "") ));
			   } else if ( count == 500 || count == 5_000 || count == 50_000 ) {
				   System.out.println(String.format("%6d%s%d", count, "th: ", n));
			   }
			}
		}
	}
	
	private static int divisorCount(int aN) {
	    int result = 1;
	    while ( ( aN & 1 ) == 0 ) {
	        result += 1;
	        aN >>= 1;
	    }
	
	    for ( int p = 3; p * p <= aN; p += 2 ) {
	        int count = 1;
	        while ( aN % p == 0 ) {
	            count += 1;
	            aN /= p;
	        }
	        result *= count;
	    }
	
	    if ( aN > 1 ) {
	        result *= 2;
	    }
	    return result;
	}

}
