import java.math.BigInteger;
import java.util.ArrayList;
import java.util.BitSet;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class HomePrimes {

	public static void main(String[] aArgs) {
		listPrimes(PRIME_LIMIT);
		
		List<Integer> values = List.of( 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 65 );
		for ( int value : values ) {
			BigInteger number = BigInteger.valueOf(value);
			List<BigInteger> previousNumbers = Stream.of( number ).collect(Collectors.toList());
			boolean searching = true;
			while ( searching ) {
				number = concatenate(primeFactors(number));
				previousNumbers.add(number);
				if ( number.isProbablePrime(CERTAINTY_LEVEL) ) {
					final int lastIndex = previousNumbers.size() - 1;
					for ( int k = lastIndex; k >= 1; k-- ) {
						System.out.print("HP" + previousNumbers.get(lastIndex - k) + "(" + k + ") = ");
					}
					System.out.println(previousNumbers.get(lastIndex));
					searching = false;
				}
			}
		}
	}
	
	private static List<BigInteger> primeFactors(BigInteger aNumber) {		
		List<BigInteger> result = new ArrayList<BigInteger>();
		
		if ( aNumber.compareTo(BigInteger.valueOf(PRIME_LIMIT * PRIME_LIMIT)) <= 0 ) {
			return smallPrimeFactors(aNumber);
		}	
		
		if ( aNumber.isProbablePrime(CERTAINTY_LEVEL) ) {
			result.add(aNumber);
			return result;
		}
		
		BigInteger divisor = pollardRho(aNumber);
    	result.addAll(primeFactors(divisor));
    	aNumber = aNumber.divide(divisor);    	
    	result.addAll(primeFactors(aNumber));
		Collections.sort(result);
		return result;
	}
	
	private static List<BigInteger> smallPrimeFactors(BigInteger aNumber) {
		int number = aNumber.intValueExact();
		List<BigInteger> result = new ArrayList<BigInteger>();
	
		for ( int i = 0; i < primes.size() && number > 1; i++ ) {
			while ( number % primes.get(i) == 0 ) {
				result.add(BigInteger.valueOf(primes.get(i)));
				number /= primes.get(i);
			}
		}
		
		if ( number > 1 ) {
			result.add(BigInteger.valueOf(number));
		}
		return result;
	}

	private static BigInteger pollardRho(BigInteger aNumber) {
		if ( ! aNumber.testBit(0) ) {
			return BigInteger.TWO;
		}		
		
		final BigInteger constant  = new BigInteger(aNumber.bitLength(), RANDOM);
		BigInteger x  = new BigInteger(aNumber.bitLength(), RANDOM);
		BigInteger y = x;
		BigInteger divisor = null;		
		
		do {
			x = x.multiply(x).add(constant).mod(aNumber);
			y = y.multiply(y).add(constant).mod(aNumber);
			y = y.multiply(y).add(constant).mod(aNumber);
			divisor = x.subtract(y).gcd(aNumber);
		} while ( divisor.compareTo(BigInteger.ONE) == 0 );
		return divisor;
	}
	
	private static BigInteger concatenate(List<BigInteger> aList) {
		String number = aList.stream().map(String::valueOf).collect(Collectors.joining());
		return new BigInteger(number);
	}
	
	public static void listPrimes(int aNumber) {
		BitSet sieve = new BitSet(aNumber + 1);
		sieve.set(2, aNumber + 1);		
		for ( int i = 2; i <= Math.sqrt(aNumber); i = sieve.nextSetBit(i + 1) ) {
			for ( int j = i * i; j <= aNumber; j = j + i ) {
				sieve.clear(j);
			}
		}
		
		primes = new ArrayList<Integer>(sieve.cardinality());
		for ( int i = 2; i >= 0; i = sieve.nextSetBit(i + 1) ) {
			primes.add(i);
		}
	}
	
	private static List<Integer> primes;
	
	private static final int CERTAINTY_LEVEL = 20;
	private static final int PRIME_LIMIT = 10_000;
	private static final ThreadLocalRandom RANDOM = ThreadLocalRandom.current();
	
}
