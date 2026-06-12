import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public final class GreatestPrimeDividingTheNthCubeFreeNumber {

	public static void main(String[] args) {
		final int limit = 10_000_000;
		createPrimes(limit);
		createCubeFree((int) (limit * 1.25));
		
		System.out.println("The first 100 terms of a370833 are:");
		for ( int i = 1; i <= 100; i++ ) {
			System.out.print(String.format("%3d%s", a370833(i).factor, ( i % 10 == 0 ? "\n" : " " )));			
		}
		System.out.println();
			
		int n = 1_000;
		while ( n <= limit ) {
		    NumberAndFactor result = a370833(n);
		    System.out.println("The " + n + "th term of a370833 is " + result.factor
		    	               + " for the cube free number " + result.number);
		    n *= 10;
		}
	}
	
	private static NumberAndFactor a370833(int n) {
	    if ( n == 1 ) {
	    	return new NumberAndFactor(1, 1);
	    }
	
	    final int nth = cubeFree.get(n - 1);
	    return new NumberAndFactor(nth, greatestPrimeFactor(nth));
	}
	
	private static void createCubeFree(int n) {
	    List<Boolean> indicators = Stream.generate( () -> true ).limit(n + 1).collect(Collectors.toList());
	
	    for ( int i = 0, prime = primes[i]; prime < Math.cbrt(n) + 1; prime = primes[++i] ) {
	        int p3 = prime * prime * prime;
	        int k = 1;
	        while ( p3 * k <= n ) {
	            indicators.set(p3 * k, false);
	            k += 1;
	        }
	    }
	
	    cubeFree = IntStream.range(1, indicators.size()).filter( i -> indicators.get(i) ).boxed().toList();
	}
	
	private static int greatestPrimeFactor(int number) {
		int largest = 0;
		for ( int i = 0, prime = primes[i]; prime <= number; prime = primes[++i] ) {
			while ( number % prime == 0 ) {
				number /= prime;
				largest = prime;
			}
		}
		return largest;
	}
	
	private static void createPrimes(int limit) {
		final int halfLimit = ( limit + 1 ) / 2;
		boolean[] composite = new boolean[halfLimit];
		for ( int i = 1, p = 3; i < halfLimit; p += 2, i++ ) {
			if ( ! composite[i] ) {
				for ( int a = i + p; a < halfLimit; a += p ) {
					composite[a] = true;
				}
			}
		}
		int[] tempPrimes = new int[composite.length];
		tempPrimes[0] = 2;
		int primesIndex = 1;
		for ( int i = 1, p = 3; i < halfLimit; p += 2, i++ ) {
			if ( ! composite[i] ) {
				tempPrimes[primesIndex++] = p;
			}
		}
		primes = Arrays.copyOfRange(tempPrimes, 0, primesIndex);
	}
	
	private static record NumberAndFactor(int number, int factor) { }
	
	private static int[] primes;
	private static List<Integer> cubeFree;

}
