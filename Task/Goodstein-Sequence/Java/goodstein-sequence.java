import java.math.BigInteger;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class GoodsteinSequence {

	public static void main(String[] args) {
		System.out.println("The Goodstein(n) sequence, up to the first 10 terms, for values of n from 0 to 7:");
		IntStream.rangeClosed(0, 7).forEach( i -> {
		    System.out.println("Goodstein of %d: %s".formatted(i, goodstein(i, 10)));
		} );
		
		System.out.println("\nThe nth term, zero based, of Goodstein(n), for values of n from 0 to 16:");
		IntStream.rangeClosed(0, 16).forEach( i -> {
		    System.out.println("Term %2d of Goodstein(%2d): %s".formatted(i, i, goodstein(i, i + 1).get(i)));
		} );
	}
	
	private static List<BigInteger> goodstein(int number, int maxTerms) {
	    BigInteger current = BigInteger.valueOf(number);
	    List<BigInteger> result = Stream.of( current ).collect(Collectors.toList());
	    int term = 1;	
	    while ( term < maxTerms && current.signum() > 0 ) {
	        current = bump(current, term + 1).subtract(BigInteger.ONE);
	        result.addLast(current);
	        term += 1;
	    }	
	    return result;
	}
	
	private static BigInteger bump(BigInteger number, int base) {
		BigInteger bigBase = BigInteger.valueOf(base);
		BigInteger result = BigInteger.ZERO;
		int i = 0;
		while ( number.signum() > 0 ) {
			BigInteger remainder = number.mod(bigBase);
			number = number.divide(bigBase);
			if ( remainder.signum() > 0 ) {
				final int exponent = bump(BigInteger.valueOf(i), base).intValueExact();
				result = result.add(remainder.multiply(bigBase.add(BigInteger.ONE).pow(exponent)));
			}
			i += 1;
		}
		return result;
	}

}
