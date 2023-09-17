import java.math.BigInteger;

public final class RepunitPrimes {

	public static void main(String[] aArgs) {
		final int limit = 2_700;
		System.out.println("Repunit primes, up to " + limit + " digits, in:");
		for ( int base = 2; base <= 16; base++ ) {
			System.out.print(String.format("%s%2s%s", "Base ", base, ": "));
			String repunit = "";
			while ( repunit.length() < limit ) {
			    repunit += "1";
			    if ( BigInteger.valueOf(repunit.length()).isProbablePrime(CERTAINTY_LEVEL) ) {
			    	BigInteger value = new BigInteger(repunit, base);
					if ( value.isProbablePrime(CERTAINTY_LEVEL) ) {
						System.out.print(repunit.length() + " ");
					}
			    }			
			}
			System.out.println();
		}
	}
	
	private static final int CERTAINTY_LEVEL = 20;

}
