import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class EvenNumbersWhichCannotBeExpressedAsTheSumOfTwoTwinPrimes {

	public static void main(String[] args) {
		final int limit = 5_000;
		List<Integer> primes = listPrimeNumbers(limit);		
		List<Integer> twinPrimes = listTwinPrimes(primes);
		
		System.out.println("Non twin prime sums:");
		List<Integer> nonTwinPrimeSums = nonTwinSums(twinPrimes, limit);
		for ( int i = 0; i < nonTwinPrimeSums.size(); i++ ) {
			System.out.print("%4d%s".formatted(nonTwinPrimeSums.get(i), ( i % 10 == 9 ? "\n" : " " )));
		}

		System.out.println("\n\nNon twin prime sums (including 1):");
		twinPrimes.addAll(0, List.of( 0, 1 ));
		nonTwinPrimeSums= nonTwinSums(twinPrimes, limit);
		for ( int i = 0; i < nonTwinPrimeSums.size(); i++ ) {
			System.out.print("%4d%s".formatted(nonTwinPrimeSums.get(i), ( i % 10 == 9 ? "\n" : " " )));
		}
	}
	
	private static List<Integer> nonTwinSums(List<Integer> twinPrimes, int limit) {
	    List<Boolean> sieve = Stream.generate( () -> false ).limit(limit + 1).collect(Collectors.toList());
	    for ( int i = 0; i < twinPrimes.size(); i++ ) {
	        for ( int j = i; j < twinPrimes.size(); j++ ) {
	            final int sum = twinPrimes.get(i) + twinPrimes.get(j);
	            if ( sum > limit ) {
	            	break;
	            }
	            sieve.set(sum, true);
	        }
	    }
	
	    List<Integer> result = new ArrayList<Integer>();
	    int i = 2;
	    while ( i < limit ) {
	        if ( ! sieve.get(i) ) {
	        	result.addLast(i);
	        }
	        i += 2;
	    }
	    return result;
	}
	
	private static List<Integer> listTwinPrimes(List<Integer> primes) {
		List<Integer> twins = Stream.of( 3 ).collect(Collectors.toList());
		for ( int i = 2; i < primes.size() - 1; i++ ) {
		    if ( primes.get(i + 1) - primes.get(i) == 2 ) {
		        if ( twins.getLast() != primes.get(i) ) {
		        	twins.addLast(primes.get(i));
		        }
		        twins.addLast(primes.get(i + 1));
		    }
		}
		return twins;
	}
	
	private static List<Integer> listPrimeNumbers(int limit) {
		List<Integer> primes = new ArrayList<Integer>();
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
		return primes;
	}	

}
