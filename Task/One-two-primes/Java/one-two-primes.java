import java.math.BigInteger;

public final class OneTwoPrimes {

	public static void main(String[] args) {
		for ( int n = 1; n <= 20; n++ ) {
			System.out.println(String.format("%4d%s%d", n, ": ", oneTwoPrimes(n)));
		}
		
		for ( int n = 100; n <= 2_000; n += 100 ) {
			String result = oneTwoPrimes(n).toString();
			final int index = result.toString().indexOf("2");
			System.out.println(String.format(
				"%4d%s%4d%s%s", n, ": (1 x ", index, ") ", result.substring(index)));
		}
	}
	
	// Based on Chai Wah Wu's Python code at www.oeis.org/A036229
	private static BigInteger oneTwoPrimes(int n) {
		BigInteger k = BigInteger.TEN.pow(n).divide(BigInteger.valueOf(9));
		BigInteger r = BigInteger.ONE.shiftLeft(n);
		BigInteger m = BigInteger.ZERO;
		while ( m.compareTo(r) <= 0 ) {
			BigInteger t = k.add( new BigInteger(m.toString(2)) );
			if ( t.isProbablePrime(15) ) {	
				return t;
			}
			m = m.add(BigInteger.ONE);
		}
		return BigInteger.ONE.negate();
	}

}
