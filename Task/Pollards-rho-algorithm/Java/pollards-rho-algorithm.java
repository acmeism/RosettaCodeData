import java.math.BigInteger;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;

public final class PollardsRhoAlgorithm {

	public static void main(String[] args) {
		List<BigInteger> tests = List.of( new BigInteger("4294967213"),
                                          new BigInteger("9759463979"),
			                              new BigInteger("34225158206557151"),
			                              new BigInteger("763218146048580636353"),
                                          new BigInteger("13")
			                            );
		
		tests.forEach( test -> {
			final BigInteger divisorOne = pollardsRho(test);
			final BigInteger divisorTwo = test.divide(divisorOne);
			System.out.println(test + " = " + divisorOne + " * " + divisorTwo);		
		} );
	}
	
	private static BigInteger pollardsRho(BigInteger aNumber) {
		if ( ! aNumber.testBit(0) ) {
			return BigInteger.TWO;
		}		
		
		final BigInteger constant = new BigInteger(aNumber.bitLength(), RANDOM);
		BigInteger x = new BigInteger(aNumber.bitLength(), RANDOM);
		BigInteger y = x;
		BigInteger divisor = BigInteger.ONE;		
		
		do {
			x = x.multiply(x).add(constant).mod(aNumber);
			y = y.multiply(y).add(constant).mod(aNumber);
			y = y.multiply(y).add(constant).mod(aNumber);
			divisor = x.subtract(y).gcd(aNumber);
		} while ( divisor.compareTo(BigInteger.ONE) == 0 );
		
		return divisor;
	}
	
	private static final ThreadLocalRandom RANDOM = ThreadLocalRandom.current();

}
