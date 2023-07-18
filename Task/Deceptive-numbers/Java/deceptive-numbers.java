public final class DeceptiveNumbers {

	public static void main(String[] aArgs) {
		int n = 7;
		int count = 0;
		while ( count < 100 ) {
			if ( isDeceptive(n) ) {
				System.out.print(String.format("%6d%s", n, ( ++count % 10 == 0 ? "\n" : " " )));
			}
			n += 1;
		}
	}
	
	private static boolean isDeceptive(int aN) {
		if ( aN % 2 != 0 && aN % 3 != 0 && aN % 5 != 0 && modulusPower(10, aN - 1, aN) == 1 ) {
			for ( int divisor = 7; divisor < Math.sqrt(aN); divisor += 6 ) {
				if ( aN % divisor == 0 || aN % ( divisor + 4 ) == 0 ) {
					return true;
				}
			}
		}
		return false;
	}
	
	private static long modulusPower(long aBase, long aExponent, long aModulus) {
	    if ( aModulus == 1 ) {
	        return 0;
	    }	
	
	    aBase %= aModulus;
	    long result = 1;
	    while ( aExponent > 0 ) {
	        if ( ( aExponent  & 1 ) == 1 ) {
	            result = ( result * aBase ) % aModulus;
	        }
	        aBase = ( aBase * aBase ) % aModulus;
	        aExponent >>= 1;
	    }
	    return result;
	}
	
}
