import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

public final class CompositeNumbersK {

	public static void main(String[] aArgs) {
		int k = 11 * 11;
		List<Integer> result = new ArrayList<Integer>();
		while ( result.size() < 20 ) {
		    while ( k % 3 == 0 || k % 5 == 0 || k % 7 == 0 ) {
		        k += 2;
		    }
		
		    List<Integer> factors = primeFactors(k);
    	    if ( factors.size() > 1 ) {
    	        String stringK = String.valueOf(k);
    	        if ( factors.stream().allMatch( factor -> stringK.indexOf(String.valueOf(factor)) >= 0 ) ) {
    	            result.add(k);
    	        }
    	    }
    	    k += 2;		
		}
		
		for ( int i = 0; i < result.size(); i++ ) {
			System.out.print(String.format("%10d%s", result.get(i), ( i == 9 || i == 19 ? "\n" : "" )));
		}
	}
	
	private static List<Integer> primeFactors(int aK) {		
		ArrayList<Integer> result = new ArrayList<Integer>();
		if ( aK <= 1 ) {
			return result;
		}
		
		BigInteger bigK = BigInteger.valueOf(aK);
		if ( bigK.isProbablePrime(CERTAINTY_LEVEL) ) {
			result.add(aK);
			return result;
		}
		
		int divisor = pollardsRho(bigK).intValueExact();
		result.addAll(primeFactors(divisor));
		result.addAll(primeFactors(aK / divisor));
		Collections.sort(result);
		return result;
	}		
	
	private static BigInteger pollardsRho(BigInteger aN) {
		final BigInteger constant  = new BigInteger(aN.bitLength(), RANDOM);
		BigInteger x  = new BigInteger(aN.bitLength(), RANDOM);
		BigInteger xx = x;
		BigInteger divisor = null;
		
		if ( aN.mod(BigInteger.TWO).signum() == 0 ) {
			return BigInteger.TWO;
		}
		
		do {
			x = x.multiply(x).mod(aN).add(constant).mod(aN);
			xx = xx.multiply(xx).mod(aN).add(constant).mod(aN);
			xx = xx.multiply(xx).mod(aN).add(constant).mod(aN);
			divisor = x.subtract(xx).gcd(aN);
		} while ( divisor.compareTo(BigInteger.ONE) == 0 );
		
		return divisor;
	}	
	
	private static final ThreadLocalRandom RANDOM = ThreadLocalRandom.current();
	private static final int CERTAINTY_LEVEL = 10;

}
