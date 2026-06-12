import java.util.ArrayList;
import java.util.List;

public final class SumOfTwoAdjacentNumbersArePrimes {

	public static void main(String[] args) {
		List<Integer> primes = listPrimeNumbers(200_000_000);
		
		System.out.println("The first 20 pairs of natural numbers whose sum is prime:");
		for ( int i = 1; i <= 20; i++ ) {
		    final int prime = primes.get(i);
		    final int halfPrime = prime / 2;
		    System.out.println("%2d + %2d = %2d".formatted(halfPrime, halfPrime + 1, prime));
		}
		System.out.println();
		
		System.out.println("The 10 millionth such pair is:");
		final int prime = primes.get(10_000_000);
		final int halfPrime = prime / 2;
		System.out.println("%2d + %2d = %2d".formatted(halfPrime, halfPrime + 1, prime));
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
