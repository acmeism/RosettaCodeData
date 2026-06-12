import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class NoPrimeSums {

	public static void main(String[] args) {
		createListOfPrimes(100_000_000);
		final int limit = 10;
		
		System.out.println("Sequence, starting with 1, then:" + System.lineSeparator());
		for ( Parity parity : Parity.values() ) {
		    System.out.print("lexicographically earliest " + parity.text
		    	+ "integer such that no subsequence sums to a prime: " + System.lineSeparator());
		    System.out.println(noPrimeSums(1, limit, parity) + System.lineSeparator());
		}
	}
	
	private static List<Integer> noPrimeSums(int start, int limit, Parity parity) {
		final int step = ( parity == Parity.BOTH ) ? 1 : 2;
		int k = ( parity == Parity.EVEN ) ? 2 : 3;
		List<Integer> sums = Stream.of( 0, start ).collect(Collectors.toList());
	    List<Integer> result = Stream.of( start ).collect(Collectors.toList());	

		while ( result.size() < limit ) {
			do {
				boolean valid = true;
				for ( int sum : sums ) {
					if ( Collections.binarySearch(primes, sum + k) >= 0 ) {
						valid = false;
						break; // for-next loop
					}
				}
				
				if ( valid ) {
					break; // do-while loop
				}
				
				k += step;
			} while ( true );

			if ( ( parity == Parity.EVEN && k % 2 == 0 ) ||
				 ( parity == Parity.ODD  && k % 2 == 1 ) ||
				   parity == Parity.BOTH ) {
				final int size = sums.size();
				for ( int i = 0; i < size; i++ ) {
					sums.addLast(sums.get(i) + k);
				}
				result.addLast(k);
			}

			k += step;
		}

		return result;
	}
	
	private static void createListOfPrimes(int limit) {
		primes = new ArrayList<Integer>();
		primes.add(2);
		final int halfLimit = ( limit + 1 ) / 2;
		boolean[] composite = new boolean[halfLimit];
		for ( int i = 1, p = 3; i < halfLimit; p += 2, i++ ) {
			if ( ! composite[i] ) {
				primes.add(p);
				for ( int a = i + p; a < halfLimit; a += p ) {
					composite[a] = true;
				}
			}
		}
	}
	
	private enum Parity {		
		BOTH(""), EVEN("even "), ODD("odd ");
		
		private Parity(String aText) {
			text = aText;
		}		
	
		private String text;	
	}
	
	private static List<Integer> primes;

}
