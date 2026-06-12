import java.util.ArrayList;
import java.util.List;
import java.util.stream.IntStream;

public final class PrimeNumbersWhichContain123 {

	public static void main(String[] args) {
		List<Integer> primes123 = listPrimeNumbers(1_000_000)
			.stream().filter( p -> Integer.toString(p).contains("123") ).toList();
		
		List<Integer> smallPrimes123 = primes123.stream().takeWhile( i -> i < 100_000 ).toList();
		
		System.out.println("Primes under 100,000 which contain '123':");
		IntStream.range(0, smallPrimes123.size()).forEach( i ->
			System.out.print(String.format("%5d%s", smallPrimes123.get(i), ( i % 10 == 9 ? "\n" : " " ))) );

		System.out.println(System.lineSeparator());
		
		System.out.println("Found " + smallPrimes123.size() + " primes less than 100,000 containing '123'.");
		System.out.println();
		System.out.println("Found " + primes123.size() + " primes less than 1,000,000 containing '123'.");

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
