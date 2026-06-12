import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;
import java.util.stream.LongStream;

public final class KempnerNumbers {

	public static void main(String[] args) {
		listPrimeNumbers(1_000_000);
		fillFactorials(100);
		
		IntStream.rangeClosed(1, 50).forEach( i -> {
			System.out.print("%3d%s".formatted(kempner(i), ( i % 10 == 0 ? "\n" : " ")));
		} );
		System.out.println();
		
		LongStream.rangeClosed(77_135_679_311L, 77_135_679_321L).forEach( i -> {
	        System.out.println("S(%d) = %d".formatted(i, kempner(i)));
		} );
	}
	
	private static long kempner(long number) {
		if ( number == 1 ) {
			return number;
		}
		
		Map<Long, Integer> factorisation = factorisation(number);
		factorisation.entrySet().stream().forEach( s -> {
			final long prime = s.getKey();
			final long value = (long) Math.pow(s.getKey(), s.getValue());
			if ( prime * prime < value ) {
		        for ( int i = 1; i < factorials.size(); i++ ) {
		            if ( factorials.get(i).mod(BigInteger.valueOf(value)).signum() == 0 ) {
		                factorisation.put(prime, i / (int) prime);
		                break;
		            }
		        }
			}
		} );

		return factorisation.entrySet().stream().mapToLong( s -> s.getKey() * s.getValue() ).max().getAsLong();
	}
	
	private static Map<Long, Integer> factorisation(long number) {
		Map<Long, Integer> result = new HashMap<Long, Integer>();
		if ( number <= 1 ) {
			return result;
		}
		
	    for ( long prime : primes ) {
	        if ( prime * prime > number ) {
	        	break;
	        }
	        int exponent = 0;
	        while ( number % prime == 0 ) {
	        	number /= prime;
	        	exponent += 1;
	        }
	        if ( exponent > 0 ) {
	        	result.put(prime, exponent);
	        }
	    }
	    if ( number > 1 ) {
	    	result.put(number, 1);
	    }	
	    return result;
	}
	
	private static void fillFactorials(int limit) {
		factorials = new ArrayList<BigInteger>();
		factorials.addLast(BigInteger.ONE);
		
		IntStream.rangeClosed(1, limit).forEach( i -> {
			factorials.addLast(factorials.getLast().multiply(BigInteger.valueOf(i)));
		} );
	}
	
	private static void listPrimeNumbers(int limit) {
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
	
	private static List<Integer> primes;
	private static List<BigInteger> factorials;

}
