import java.util.BitSet;
import java.util.function.Predicate;
import java.util.stream.IntStream;

public final class TripletOfThreeNumbers {

	public static void main(String[] args) {
		final int limit = 6_000;
		BitSet primes = generatePrimes(limit);
		
		Predicate<Integer> triplet = n -> n >= 2 && primes.get(n - 1) && primes.get(n + 3) && primes.get(n + 5);
		
		IntStream.range(2, limit).forEach( n -> {
	        if ( triplet.test(n) ) {
	        	System.out.println(String.format("%4d: %4d, %4d, %4d", n, n - 1, n + 3, n + 5));
	        }
	    } );
	}
	
	private static BitSet generatePrimes(int limit) {
	    BitSet primes = new BitSet(limit);
	    primes.set(2, limit);	
	    IntStream.rangeClosed(2, (int) Math.sqrt(limit)).forEach( i -> {
	        if ( primes.get(i)) {
	        	IntStream.iterate(2 * i, j -> j + i).limit(limit).forEach( j -> {
	                primes.set(j, false);
	            } );
	        }
	    } );	
	    return primes;
	}

}
